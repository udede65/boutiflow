import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/providers.dart';
import '../../core/models/entities.dart';
import '../../providers/booking_providers.dart';
import '../../services/pdf_service.dart';
import '../../core/widgets/premium_gate.dart';
import '../../core/services/plan_limits.dart';
import '../../core/widgets/upgrade_prompt.dart';
import '../../state/app_state.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../core/services/interstitial_ad_service.dart';
import '../paywall/paywall_provider.dart';
import '../guests/guest_form_screen.dart';
import '../../core/widgets/banner_ad_widget.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  const BookingFormScreen({
    super.key,
    this.bookingId,
    this.initialRoomId,
    this.initialDate,
  });

  final String? bookingId;
  final String? initialRoomId;
  final DateTime? initialDate;

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _checkIn;
  late DateTime _checkOut;
  String? _selectedGuestId;
  String? _selectedRoomId;
  final _priceController = TextEditingController();
  bool _isLoading = false;
  bool _isInit = true;
  bool _isHourly = false;

  late BookingStatus _status; // Add status variable
  late String _source; // Add source variable

  List<Payment> _payments = [];

  @override
  void initState() {
    super.initState();
    _checkIn = widget.initialDate ?? DateTime.now();
    _checkOut = _checkIn.add(const Duration(days: 1));
    _selectedRoomId = widget.initialRoomId;
    _status = BookingStatus.reserved; // Default
    _source = 'direct'; // Default source
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit && widget.bookingId != null) {
      _loadBooking();
      _loadPayments();
      _isInit = false;
    }
  }

  Future<void> _loadBooking() async {
    // In a real app, fetch single booking. For now, finding in list.
    final bookings = await ref.read(bookingsProvider.future);
    try {
      final booking = bookings.firstWhere((b) => b.id == widget.bookingId);
      setState(() {
        _checkIn = booking.checkIn;
        _checkOut = booking.checkOut;
        _selectedGuestId = booking.guest.id;
        _selectedRoomId = booking.room.id;
        _priceController.text = booking.priceTotal?.toString() ?? '';
        _status = booking.status; // Load status
        _source = booking.source; // Load source
        _isHourly = booking.isHourly; // Load isHourly
      });
    } catch (_) {
      // Booking not found
    }
  }

  Future<void> _loadPayments() async {
    if (widget.bookingId == null) return;
    final payments = await ref
        .read(boutiFlowServiceProvider)
        .fetchPayments(widget.bookingId!);
    setState(() {
      _payments = payments;
    });
  }

  InputDecoration _neoInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: NeoBrutalistTheme.bodyMedium,
      filled: true,
      fillColor: NeoBrutalistTheme.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: NeoBrutalistTheme.black, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: NeoBrutalistTheme.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: NeoBrutalistTheme.blue, width: 3),
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
          if (_checkOut.isBefore(_checkIn)) {
            _checkOut = _checkIn.add(const Duration(days: 1));
          }
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  Future<void> _selectSingleDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkIn = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _checkIn.hour,
          _checkIn.minute,
        );
        _checkOut = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _checkOut.hour,
          _checkOut.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isCheckIn) async {
    final initialTime = TimeOfDay.fromDateTime(isCheckIn ? _checkIn : _checkOut);
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = DateTime(
            _checkIn.year,
            _checkIn.month,
            _checkIn.day,
            picked.hour,
            picked.minute,
          );
          if (_checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn)) {
            _checkOut = _checkIn.add(const Duration(hours: 2));
          }
        } else {
          _checkOut = DateTime(
            _checkOut.year,
            _checkOut.month,
            _checkOut.day,
            picked.hour,
            picked.minute,
          );
        }
      });
    }
  }

  Future<void> _showAddRoomDialog(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    
    // Check Plan Limits
    final userPlan = ref.read(appStateProvider).user?.plan ?? PlanType.free;
    final roomsAsync = ref.read(roomsProvider);
    final roomCount = roomsAsync.value?.length ?? 0;

    if (!PlanLimits.canAddRoom(userPlan, roomCount)) {
      UpgradePrompt.show(
        context,
        feature: l10n.t('roomLimitFeature'),
        message: l10n.tf('freePlanRoomLimit', {
          'count': PlanLimits.freeMaxRooms,
        }),
      );
      return;
    }

    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '2');

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeoBrutalistTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
        ),
        title: Text(l10n.upper('addRoom'), style: NeoBrutalistTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: NeoBrutalistTheme.bodyLarge,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.t('roomName'),
                hintText: l10n.t('roomNameExample'),
                labelStyle: NeoBrutalistTheme.bodyMedium,
                filled: true,
                fillColor: NeoBrutalistTheme.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: NeoBrutalistTheme.black, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: NeoBrutalistTheme.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: capacityController,
              style: NeoBrutalistTheme.bodyLarge,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.t('capacity'),
                labelStyle: NeoBrutalistTheme.bodyMedium,
                filled: true,
                fillColor: NeoBrutalistTheme.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: NeoBrutalistTheme.black, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: NeoBrutalistTheme.black, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.upper('cancel'),
                style: NeoBrutalistTheme.labelLarge
                    .copyWith(color: NeoBrutalistTheme.grey)),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(ctx, true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
              child: Text(l10n.upper('save'),
                  style: NeoBrutalistTheme.labelLarge
                      .copyWith(color: NeoBrutalistTheme.white)),
            ),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      final hotelId = ref.read(appStateProvider).user?.hotelId ?? '';
      await ref.read(boutiFlowServiceProvider).createRoom(
            nameController.text,
            hotelId: hotelId,
            capacity: int.tryParse(capacityController.text) ?? 2,
          );
      ref.invalidate(roomsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.tf('roomAdded', {'name': nameController.text})),
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_formKey.currentState!.validate() &&
        _selectedGuestId != null &&
        _selectedRoomId != null) {
      setState(() => _isLoading = true);
      try {
        final service = ref.read(boutiFlowServiceProvider);
        final price = double.tryParse(_priceController.text);

        // 1. Time range check (check-out must be after check-in)
        if (_checkOut.isBefore(_checkIn) || _checkOut.isAtSameMomentAs(_checkIn)) {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.t('invalidTimeRange')),
                backgroundColor: NeoBrutalistTheme.red,
              ),
            );
          }
          return;
        }

        // 2. Conflict/overlap validation
        final bookings = await ref.read(bookingsProvider.future);
        final hasConflict = bookings.any((b) =>
            b.room.id == _selectedRoomId &&
            b.id != widget.bookingId &&
            b.status != BookingStatus.cancelled &&
            _checkIn.isBefore(b.checkOut) &&
            _checkOut.isAfter(b.checkIn));

        if (hasConflict) {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.t('bookingOverlapConflict')),
                backgroundColor: NeoBrutalistTheme.red,
              ),
            );
          }
          return;
        }

        if (widget.bookingId != null) {
          // Update
          // We need to reconstruct the booking object.
          // Ideally we should fetch the original to keep other fields like status.
          // For simplicity, we'll create a new object with updated fields.
          // BUT wait, we need the original object to pass to updateBooking or at least its ID.
          // The service updateBooking takes a Booking entity.

          // Let's fetch the original first to be safe
          final original = bookings.firstWhere((b) => b.id == widget.bookingId);

          final updated = original.copyWith(
            room: Room(
                id: _selectedRoomId!,
                name: '',
                capacity: 0,
                status: RoomStatus.clean), // ID is what matters for update
            guest: Guest(
                id: _selectedGuestId!,
                name: '',
                languageCode: ''), // ID matters
            checkIn: _checkIn,
            checkOut: _checkOut,
            priceTotal: price ?? 0,
            status: _status, // Update status
            source: _source, // Update source
            isHourly: _isHourly, // Update isHourly
          );

          await service.updateBooking(updated);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.t('bookingUpdated'))),
            );
          }
        } else {
          // Create - Check booking limit first
          final user = ref.read(appStateProvider).user;
          final userPlan = user?.plan ?? PlanType.free;
          final totalBookings = bookings.length;

          if (!PlanLimits.canAddBooking(userPlan, totalBookings)) {
            setState(() => _isLoading = false);
            if (mounted) {
              UpgradePrompt.show(
                context,
                feature: l10n.t('roomLimitFeature'),
                message: l10n.tf(
                  'freePlanBookingLimit',
                  {'count': PlanLimits.freeMaxBookingsTotal},
                ),
              );
            }
            return;
          }

          final hotelId = ref.read(appStateProvider).user?.hotelId ?? '';
          await service.createBooking(
            hotelId: hotelId,
            roomId: _selectedRoomId!,
            guestId: _selectedGuestId!,
            checkIn: _checkIn,
            checkOut: _checkOut,
            price: price,
            source: _source,
            isHourly: _isHourly, // Create with isHourly
          );

          if (!ref.read(isProProvider)) {
            InterstitialAdService.instance.showAd();
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.t('bookingCreated'))),
            );
          }
        }

        if (mounted) {
          context.pop();
          // Refresh bookings
          ref.invalidate(bookingsProvider);
          ref.invalidate(dashboardProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else if (_selectedGuestId == null || _selectedRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('selectGuestRoom'))),
      );
    }
  }

  Future<void> _delete() async {
    if (widget.bookingId == null) return;
    final l10n = context.l10n;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('deleteBookingTitle')),
        content: Text(l10n.t('deleteBookingConfirmation')),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(l10n.t('cancel')),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(
              l10n.t('delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(boutiFlowServiceProvider)
            .deleteBooking(widget.bookingId!);
        if (mounted) {
          context.pop();
          ref.invalidate(bookingsProvider);
          ref.invalidate(dashboardProvider);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currencySymbol =
        getCurrencySymbol(ref.watch(appStateProvider).user?.currency ?? 'EUR');
    final guestsAsync = ref.watch(futureGuestsProvider);
    final roomsAsync = ref.watch(roomsProvider); // Use the shared provider

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoBrutalistTheme.cream,
        foregroundColor: NeoBrutalistTheme.black,
        elevation: 0,
        title: Text(
          widget.bookingId != null
              ? l10n.upper('editBookingTitle')
              : l10n.upper('newBooking'),
          style: NeoBrutalistTheme.titleLarge,
        ),
        actions: [
          if (widget.bookingId != null) ...[
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: l10n.t('exportPdf'),
              onPressed: () => _showPdfOptions(context, l10n),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _delete,
            ),
          ],
        ],
      ),
      bottomNavigationBar: !ref.watch(isProProvider)
          ? const SafeArea(
              top: false,
              child: BannerAdWidget(),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // === GUEST & ROOM SECTION ===
              NeoCard(
                color: NeoBrutalistTheme.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.upper('guestAndRoom'),
                        style: NeoBrutalistTheme.labelLarge),
                    const SizedBox(height: 12),

                    // Guest Selector
                    guestsAsync.when(
                      data: (guests) => Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGuestId,
                              style: NeoBrutalistTheme.bodyLarge,
                              decoration: _neoInputDecoration(l10n.t('guest')),
                              dropdownColor: NeoBrutalistTheme.white,
                              focusColor: Colors.transparent,
                              items: guests.map((g) {
                                return DropdownMenuItem(
                                    value: g.id, child: Text(g.name));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedGuestId = val),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GuestFormScreen(),
                                ),
                              );
                              ref.invalidate(futureGuestsProvider);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: NeoBrutalistTheme.cardDecoration(
                                  NeoBrutalistTheme.purple),
                              child: const Icon(Icons.person_add_rounded,
                                  color: NeoBrutalistTheme.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      loading: () => const LinearProgressIndicator(
                          color: NeoBrutalistTheme.blue),
                      error: (e, s) =>
                          Text(l10n.tf('errorWithMessage', {'error': e})),
                    ),
                    const SizedBox(height: 16),

                    // Room Selector
                    roomsAsync.when(
                      data: (rooms) => Row(
                        children: [
                          Expanded(
                            child: rooms.isEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: NeoBrutalistTheme.white,
                                      border: Border.all(
                                          color: NeoBrutalistTheme.black,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(l10n.t('noRooms'),
                                        style: NeoBrutalistTheme.bodyMedium),
                                  )
                                : DropdownButtonFormField<String>(
                                    value: _selectedRoomId,
                                    style: NeoBrutalistTheme.bodyLarge,
                                    decoration:
                                        _neoInputDecoration(l10n.t('room')),
                                    dropdownColor: NeoBrutalistTheme.white,
                                    focusColor: Colors.transparent,
                                    items: rooms.map((r) {
                                      return DropdownMenuItem(
                                          value: r.id, child: Text(r.name));
                                    }).toList(),
                                    onChanged: (val) =>
                                        setState(() => _selectedRoomId = val),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showAddRoomDialog(context, ref),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: NeoBrutalistTheme.cardDecoration(
                                  NeoBrutalistTheme.orange),
                              child: const Icon(Icons.add_home_rounded,
                                  color: NeoBrutalistTheme.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      loading: () => const LinearProgressIndicator(
                          color: NeoBrutalistTheme.blue),
                      error: (e, s) =>
                          Text(l10n.tf('errorWithMessage', {'error': e})),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === DATE SECTION ===
              NeoCard(
                color: NeoBrutalistTheme.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.t('dates').toUpperCase(),
                          style: NeoBrutalistTheme.labelLarge,
                        ),
                        Row(
                          children: [
                            Text(
                              l10n.t('hourlyBooking'),
                              style: NeoBrutalistTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: _isHourly,
                              activeColor: NeoBrutalistTheme.blue,
                              onChanged: (val) {
                                setState(() {
                                  _isHourly = val;
                                  if (_isHourly) {
                                    final now = DateTime.now();
                                    _checkIn = DateTime(now.year, now.month, now.day, 15, 0);
                                    _checkOut = DateTime(now.year, now.month, now.day, 17, 0);
                                  } else {
                                    final now = DateTime.now();
                                    _checkIn = DateTime(now.year, now.month, now.day);
                                    _checkOut = _checkIn.add(const Duration(days: 1));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: NeoBrutalistTheme.black, thickness: 1.5),
                    const SizedBox(height: 12),
                    if (_isHourly) ...[
                      GestureDetector(
                        onTap: () => _selectSingleDate(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: NeoBrutalistTheme.yellow,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: NeoBrutalistTheme.black, width: 2),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.calendar_month_rounded,
                                  color: NeoBrutalistTheme.black),
                              const SizedBox(height: 4),
                              Text(l10n.upper('date'),
                                  style: NeoBrutalistTheme.labelLarge
                                      .copyWith(
                                          color: NeoBrutalistTheme.black,
                                          fontSize: 10)),
                              Text(
                                DateFormat('dd MMMM yyyy', l10n.locale.languageCode).format(_checkIn),
                                style: NeoBrutalistTheme.titleMedium
                                    .copyWith(
                                        color: NeoBrutalistTheme.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(context, true),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: NeoBrutalistTheme.blue,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: NeoBrutalistTheme.black, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: NeoBrutalistTheme.white),
                                    const SizedBox(height: 4),
                                    Text(l10n.upper('checkInTime'),
                                        style: NeoBrutalistTheme.labelLarge
                                            .copyWith(
                                                color: NeoBrutalistTheme.white,
                                                fontSize: 10)),
                                    Text(
                                      DateFormat.Hm(l10n.locale.languageCode).format(_checkIn),
                                      style: NeoBrutalistTheme.titleMedium
                                          .copyWith(
                                              color: NeoBrutalistTheme.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(context, false),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: NeoBrutalistTheme.red,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: NeoBrutalistTheme.black, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: NeoBrutalistTheme.white),
                                    const SizedBox(height: 4),
                                    Text(l10n.upper('checkOutTime'),
                                        style: NeoBrutalistTheme.labelLarge
                                            .copyWith(
                                                color: NeoBrutalistTheme.white,
                                                fontSize: 10)),
                                    Text(
                                      DateFormat.Hm(l10n.locale.languageCode).format(_checkOut),
                                      style: NeoBrutalistTheme.titleMedium
                                          .copyWith(
                                              color: NeoBrutalistTheme.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, true),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: NeoBrutalistTheme.blue,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: NeoBrutalistTheme.black, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.login_rounded,
                                        color: NeoBrutalistTheme.white),
                                    const SizedBox(height: 4),
                                    Text(l10n.upper('checkIn'),
                                        style: NeoBrutalistTheme.labelLarge
                                            .copyWith(
                                                color: NeoBrutalistTheme.white,
                                                fontSize: 10)),
                                    Text(
                                      DateFormat('dd MMM').format(_checkIn),
                                      style: NeoBrutalistTheme.titleMedium
                                          .copyWith(
                                              color: NeoBrutalistTheme.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context, false),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: NeoBrutalistTheme.red,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: NeoBrutalistTheme.black, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.logout_rounded,
                                        color: NeoBrutalistTheme.white),
                                    const SizedBox(height: 4),
                                    Text(l10n.upper('checkOut'),
                                        style: NeoBrutalistTheme.labelLarge
                                            .copyWith(
                                                color: NeoBrutalistTheme.white,
                                                fontSize: 10)),
                                    Text(
                                      DateFormat('dd MMM').format(_checkOut),
                                      style: NeoBrutalistTheme.titleMedium
                                          .copyWith(
                                              color: NeoBrutalistTheme.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === DETAILS SECTION ===
              NeoCard(
                color: NeoBrutalistTheme.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.upper('details'),
                        style: NeoBrutalistTheme.labelLarge),
                    const SizedBox(height: 12),

                    // Status (only for edit)
                    if (widget.bookingId != null) ...[
                      DropdownButtonFormField<BookingStatus>(
                        value: _status,
                        style: NeoBrutalistTheme.bodyLarge,
                        decoration: _neoInputDecoration(l10n.t('status')),
                        dropdownColor: NeoBrutalistTheme.white,
                        focusColor: Colors.transparent,
                        items: BookingStatus.values.map((s) {
                          return DropdownMenuItem(
                              value: s, child: Text(_statusLabel(s, l10n)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _status = val);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Source
                    DropdownButtonFormField<String>(
                      value: _source,
                      style: NeoBrutalistTheme.bodyLarge,
                      decoration: _neoInputDecoration(l10n.t('bookingSource')),
                      dropdownColor: NeoBrutalistTheme.white,
                      focusColor: Colors.transparent,
                      items: [
                        DropdownMenuItem(
                            value: 'direct',
                            child: Text(l10n.t('sourceDirect'))),
                        DropdownMenuItem(
                            value: 'airbnb',
                            child: Text(l10n.t('sourceAirbnb'))),
                        DropdownMenuItem(
                            value: 'booking_com',
                            child: Text(l10n.t('sourceBookingCom'))),
                        DropdownMenuItem(
                            value: 'expedia',
                            child: Text(l10n.t('sourceExpedia'))),
                        DropdownMenuItem(
                            value: 'other', child: Text(l10n.t('sourceOther'))),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _source = val);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price
                    TextFormField(
                      controller: _priceController,
                      style: NeoBrutalistTheme.bodyLarge,
                      decoration: _neoInputDecoration(l10n.t('totalPrice')),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === PAYMENTS SECTION (only for edit) ===
              if (widget.bookingId != null) ...[
                NeoCard(
                  color: NeoBrutalistTheme.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.upper('payments'),
                              style: NeoBrutalistTheme.labelLarge),
                          GestureDetector(
                            onTap: _showAddPaymentDialog,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: NeoBrutalistTheme.cardDecoration(
                                  NeoBrutalistTheme.green),
                              child: const Icon(Icons.add_card_rounded,
                                  color: NeoBrutalistTheme.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_payments.isEmpty)
                        Text(l10n.t('noPaymentsYet'),
                            style: NeoBrutalistTheme.bodyMedium
                                .copyWith(color: NeoBrutalistTheme.grey))
                      else
                        ..._payments.map((p) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: NeoBrutalistTheme.cream,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: NeoBrutalistTheme.black, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${p.amount.toStringAsFixed(0)} $currencySymbol',
                                          style: NeoBrutalistTheme.titleMedium),
                                      Row(
                                        children: [
                                          Icon(
                                            _paymentMethodIcon(p.method),
                                            size: 14,
                                            color:
                                                _paymentMethodColor(p.method),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${_paymentMethodLabel(p.method, l10n)} • ${DateFormat.yMMMd(l10n.locale.languageCode).format(p.date)}',
                                            style: NeoBrutalistTheme.bodyMedium
                                                .copyWith(
                                                    color:
                                                        NeoBrutalistTheme.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => _deletePayment(p.id),
                                    child: const Icon(Icons.delete_rounded,
                                        color: NeoBrutalistTheme.red, size: 20),
                                  ),
                                ],
                              ),
                            )),
                      const SizedBox(height: 8),
                      // Balance Summary
                      Builder(
                        builder: (context) {
                          final total =
                              double.tryParse(_priceController.text) ?? 0.0;
                          final paid =
                              _payments.fold(0.0, (sum, p) => sum + p.amount);
                          final balance = total - paid;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: balance > 0
                                  ? NeoBrutalistTheme.red
                                  : NeoBrutalistTheme.green,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: NeoBrutalistTheme.black, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${l10n.t('paid')}: ${paid.toStringAsFixed(0)} $currencySymbol',
                                    style: NeoBrutalistTheme.bodyMedium
                                        .copyWith(
                                            color: NeoBrutalistTheme.white)),
                                Text(
                                  '${l10n.t('remaining')}: ${balance.toStringAsFixed(0)} $currencySymbol',
                                  style: NeoBrutalistTheme.titleMedium
                                      .copyWith(color: NeoBrutalistTheme.white),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // === SAVE BUTTON ===
              GestureDetector(
                onTap: _isLoading ? null : _submit,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: NeoBrutalistTheme.cardDecoration(
                    _isLoading
                        ? NeoBrutalistTheme.grey
                        : NeoBrutalistTheme.green,
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: NeoBrutalistTheme.white)
                        : Text(
                            widget.bookingId != null
                                ? l10n.upper('update')
                                : l10n.upper('createBooking'),
                            style: NeoBrutalistTheme.titleMedium
                                .copyWith(color: NeoBrutalistTheme.white),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(BookingStatus status, AppLocalizations l10n) {
    if (status.name == 'reserved') return l10n.t('reserved');
    if (status.name == 'checkedIn') return l10n.t('checkedIn');
    if (status.name == 'checkedOut') return l10n.t('checkedOut');
    if (status.name == 'cancelled') return l10n.t('cancelled');
    return l10n.t('reserved');
  }

  String _paymentMethodLabel(String method, AppLocalizations l10n) {
    switch (method) {
      case 'cash':
        return l10n.t('cash');
      case 'card':
        return l10n.t('card');
      case 'transfer':
        return l10n.t('bankTransfer');
      default:
        return method;
    }
  }

  IconData _paymentMethodIcon(String method) {
    switch (method) {
      case 'cash':
        return Icons.money_rounded;
      case 'card':
        return Icons.credit_card_rounded;
      case 'transfer':
        return Icons.account_balance_rounded;
      default:
        return Icons.payments_rounded;
    }
  }

  Color _paymentMethodColor(String method) {
    switch (method) {
      case 'cash':
        return NeoBrutalistTheme.green;
      case 'card':
        return NeoBrutalistTheme.blue;
      case 'transfer':
        return NeoBrutalistTheme.purple;
      default:
        return NeoBrutalistTheme.grey;
    }
  }

  Future<void> _showAddPaymentDialog() async {
    final l10n = context.l10n;
    final amountController = TextEditingController();
    String selectedMethod = 'cash';
    final currencySymbol =
        getCurrencySymbol(ref.read(appStateProvider).user?.currency ?? 'EUR');

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: NeoBrutalistTheme.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
          ),
          title: Text(l10n.upper('paymentAddTitle'),
              style: NeoBrutalistTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: amountController,
                style: NeoBrutalistTheme.bodyLarge,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.t('amount'),
                  labelStyle: NeoBrutalistTheme.bodyMedium,
                  prefixText: '$currencySymbol ',
                  filled: true,
                  fillColor: NeoBrutalistTheme.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: NeoBrutalistTheme.black, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: NeoBrutalistTheme.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.t('paymentMethodLabel'),
                  style: NeoBrutalistTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PaymentMethodChip(
                    label: l10n.t('cash'),
                    icon: Icons.money_rounded,
                    isSelected: selectedMethod == 'cash',
                    color: NeoBrutalistTheme.green,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setDialogState(() => selectedMethod = 'cash');
                    },
                  ),
                  _PaymentMethodChip(
                    label: l10n.t('card'),
                    icon: Icons.credit_card_rounded,
                    isSelected: selectedMethod == 'card',
                    color: NeoBrutalistTheme.blue,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setDialogState(() => selectedMethod = 'card');
                    },
                  ),
                  _PaymentMethodChip(
                    label: l10n.t('bankTransfer'),
                    icon: Icons.account_balance_rounded,
                    isSelected: selectedMethod == 'transfer',
                    color: NeoBrutalistTheme.purple,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      setDialogState(() => selectedMethod = 'transfer');
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.upper('cancel'),
                  style: NeoBrutalistTheme.labelLarge
                      .copyWith(color: NeoBrutalistTheme.grey)),
            ),
            GestureDetector(
              onTap: () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null && widget.bookingId != null) {
                  await ref.read(boutiFlowServiceProvider).createPayment(
                        bookingId: widget.bookingId!,
                        amount: amount,
                        date: DateTime.now(),
                        method: selectedMethod,
                        type: 'payment',
                      );

                  if (!ref.read(isProProvider)) {
                    InterstitialAdService.instance.showAd();
                  }

                  if (mounted) {
                    Navigator.pop(ctx);
                    _loadPayments();
                  }
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration:
                    NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
                child: Text(l10n.upper('add'),
                    style: NeoBrutalistTheme.labelLarge
                        .copyWith(color: NeoBrutalistTheme.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletePayment(String id) async {
    await ref.read(boutiFlowServiceProvider).deletePayment(id);
    _loadPayments();
  }

  void _showPdfOptions(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => PremiumGate(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.receipt),
                title: Text(l10n.t('invoice')),
                onTap: () async {
                  context.pop();
                  await _generatePdf(true, l10n);
                },
              ),
              ListTile(
                leading: const Icon(Icons.confirmation_number),
                title: Text(l10n.t('bookingConfirmation')),
                onTap: () async {
                  context.pop();
                  await _generatePdf(false, l10n);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generatePdf(bool isInvoice, AppLocalizations l10n) async {
    setState(() => _isLoading = true);
    try {
      final bookings = await ref.read(bookingsProvider.future);
      final booking = bookings.firstWhere((b) => b.id == widget.bookingId);
      // Need hotel profile for PDF
      // Assuming we can get it from a provider or service.
      // For now, let's create a dummy one or fetch if available.
      // Ideally, we should have a userProvider.
      // Let's fetch via service for now.
      // Wait, we don't have a direct fetchUser method exposed easily here without auth provider.
      // Let's assume a default profile if not found or fetch from settings provider if exists.

      // Quick fix: Fetch user from service (we need to add fetchUser to service or use existing)
      // The service has `currentUser` getter if we implemented it? No.
      // Let's use a hardcoded one for now or try to fetch.
      // Actually, `boutiFlowServiceProvider` has `db`. We can query users.
      final db = ref.read(boutiFlowServiceProvider).db;
      final userRow = await db.select(db.users).getSingleOrNull();

      final hotelProfile = UserProfile(
        hotelId: userRow?.hotelId ?? '',
        email: userRow?.email ?? 'hotel@example.com',
        displayName: 'Owner',
        hotelName: (await db.select(db.hotels).getSingleOrNull())?.name ??
            l10n.t('appName'),
        languageCode: 'en',
        plan: PlanType.free, // Doesn't matter here
        currency:
            (await db.select(db.hotels).getSingleOrNull())?.currency ?? 'EUR',
      );

      final pdfService = PdfService();
      if (isInvoice) {
        await pdfService.generateInvoice(booking, hotelProfile, l10n);
      } else {
        await pdfService.generateConfirmation(booking, hotelProfile, l10n);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.tf('errorGeneratingPdf', {'error': e}))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// Temporary providers for this screen
final futureGuestsProvider = FutureProvider<List<Guest>>((ref) async {
  final user = ref.read(appStateProvider).user;
  if (user == null) return <Guest>[];
  return ref.read(boutiFlowServiceProvider).fetchGuests(user.hotelId);
});

class _PaymentMethodChip extends StatelessWidget {
  const _PaymentMethodChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color : NeoBrutalistTheme.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: NeoBrutalistTheme.black,
                width: isSelected ? 3 : 2,
              ),
              boxShadow:
                  isSelected ? NeoBrutalistTheme.brutalistShadowSmall : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: isSelected ? NeoBrutalistTheme.white : color,
                    size: 20),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: NeoBrutalistTheme.labelLarge.copyWith(
                    fontSize: 10,
                    color: isSelected
                        ? NeoBrutalistTheme.white
                        : NeoBrutalistTheme.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
