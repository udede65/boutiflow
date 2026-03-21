import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../providers/booking_providers.dart';
import '../../state/app_state.dart';
import '../../features/paywall/paywall_page.dart';
import 'calendar_grid.dart';
import '../../services/ical_service.dart';
import '../../services/ical_import_service.dart';
import '../../services/providers.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../core/services/plan_limits.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  int _daysToShow = 7;
  DateTime _startDate = DateTime.now();

  void _previousPeriod() {
    setState(() {
      _startDate = _startDate.subtract(Duration(days: _daysToShow));
    });
  }

  void _nextPeriod() {
    setState(() {
      _startDate = _startDate.add(Duration(days: _daysToShow));
    });
  }

  void _jumpToToday() {
    setState(() {
      _startDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);
    final roomsAsync = ref.watch(roomsProvider);
    final user = ref.watch(appStateProvider).user;
    final l10n = context.l10n;
    final userPlan = user?.plan ?? PlanType.free;
    final hasExtendedCalendar = PlanLimits.hasExtendedCalendar(userPlan);
    final canMoveBookings = PlanLimits.hasCalendarDragDrop(userPlan);
    final hasIcalSync = PlanLimits.hasIcalSync(userPlan);
    final currencySymbol = getCurrencySymbol(user?.currency ?? 'EUR');

    const textSecondary = NeoBrutalistTheme.grey;

    final dates = List.generate(
      _daysToShow,
      (index) => _startDate.add(Duration(days: index)),
    );

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.t('calendar').toUpperCase(),
                    style: NeoBrutalistTheme.headlineLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.today_rounded, color: textSecondary),
                        onPressed: _jumpToToday,
                        tooltip: l10n.t('today'),
                      ),
                      if (!hasExtendedCalendar)
                        InkWell(
                          onTap: () => context.push('/paywall'),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: NeoBrutalistTheme.yellow,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: NeoBrutalistTheme.black, width: 2),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 14, color: NeoBrutalistTheme.black),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.upper('premiumFeature'),
                                  style: NeoBrutalistTheme.labelLarge
                                      .copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Date Range Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _previousPeriod,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                      child: const Icon(Icons.chevron_left_rounded,
                          color: NeoBrutalistTheme.black),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: NeoBrutalistTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: NeoBrutalistTheme.black, width: 2),
                    ),
                    child: Row(
                      children: [1, 3, 7, 30].map((days) {
                        final isSelected = _daysToShow == days;
                        return GestureDetector(
                          onTap: () {
                            if (!PlanLimits.canUseCalendarRange(
                                userPlan, days)) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const PaywallPage()),
                              );
                              return;
                            }
                            setState(() => _daysToShow = days);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? NeoBrutalistTheme.orange
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              days == 30
                                  ? l10n.t('monthShort')
                                  : (days == 7
                                      ? l10n.t('weekShort')
                                      : (days == 3
                                          ? l10n.t('threeDaysShort')
                                          : l10n.t('dayShort'))),
                              style: NeoBrutalistTheme.labelLarge.copyWith(
                                color: isSelected
                                    ? NeoBrutalistTheme.white
                                    : NeoBrutalistTheme.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _nextPeriod,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                      child: const Icon(Icons.chevron_right_rounded,
                          color: NeoBrutalistTheme.black),
                    ),
                  ),
                ],
              ),
            ),

            // Calendar Content
            Expanded(
              child: bookingsAsync.when(
                data: (bookings) => roomsAsync.when(
                  data: (rooms) {
                    if (rooms.isEmpty) {
                      return Center(
                          child: Text(l10n.t('noRooms'),
                              style: const TextStyle(color: NeoBrutalistTheme.grey)));
                    }
                    return CalendarGrid(
                      rooms: rooms,
                      bookings: bookings,
                      dates: dates,
                      currencySymbol: currencySymbol,
                      cellWidth: _daysToShow == 1
                          ? 200
                          : (_daysToShow <= 3 ? 100 : 70),
                      onBookingMove: (booking, newRoom, newStartDate) async {
                        if (!canMoveBookings) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const PaywallPage()),
                          );
                          return;
                        }

                        // Calculate new check-out based on duration
                        final duration =
                            booking.checkOut.difference(booking.checkIn);
                        final newCheckOut = newStartDate.add(duration);

                        try {
                          await ref
                              .read(boutiFlowServiceProvider)
                              .updateBooking(
                                booking.copyWith(
                                  room: newRoom,
                                  checkIn: newStartDate,
                                  checkOut: newCheckOut,
                                ),
                              );
                          ref.invalidate(bookingsProvider);
                          ref.invalidate(dashboardProvider);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text(l10n.t('bookingMovedSuccessfully'))),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(l10n.tf(
                                      'failedToMoveBooking', {'error': e}))),
                            );
                          }
                        }
                      },
                      onRoomTap: (room) {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: NeoBrutalistTheme.cream,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            side: BorderSide(
                                color: NeoBrutalistTheme.black, width: 3),
                          ),
                          builder: (context) => SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    room.name.toUpperCase(),
                                    style: NeoBrutalistTheme.titleLarge,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: NeoBrutalistTheme.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: NeoBrutalistTheme.black,
                                        width: 2),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration:
                                          NeoBrutalistTheme.cardDecoration(
                                              NeoBrutalistTheme.orange),
                                      child: const Icon(Icons.calendar_today,
                                          color: NeoBrutalistTheme.white,
                                          size: 20),
                                    ),
                                    title: Text(l10n.t('icalExportTitle'),
                                        style: NeoBrutalistTheme.titleMedium),
                                    subtitle: Text(l10n.t('icalExportSubtitle'),
                                        style: NeoBrutalistTheme.bodyMedium
                                            .copyWith(
                                                color: NeoBrutalistTheme.grey)),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      if (!hasIcalSync) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const PaywallPage()),
                                        );
                                        return;
                                      }

                                      try {
                                        final roomBookings = bookings
                                            .where((b) => b.room.id == room.id)
                                            .toList();
                                        await icalServiceProvider
                                            .exportRoomCalendar(
                                                room, roomBookings);
                                      } catch (e) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(l10n.tf(
                                                      'icalExportFailed',
                                                      {'error': e}))));
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: NeoBrutalistTheme.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: NeoBrutalistTheme.black,
                                        width: 2),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration:
                                          NeoBrutalistTheme.cardDecoration(
                                              NeoBrutalistTheme.blue),
                                      child: const Icon(Icons.cloud_download,
                                          color: NeoBrutalistTheme.white,
                                          size: 20),
                                    ),
                                    title: Text(l10n.t('icalImportTitle'),
                                        style: NeoBrutalistTheme.titleMedium),
                                    subtitle: Text(l10n.t('icalImportSubtitle'),
                                        style: NeoBrutalistTheme.bodyMedium
                                            .copyWith(
                                                color: NeoBrutalistTheme.grey)),
                                    onTap: () {
                                      Navigator.pop(context);
                                      if (!hasIcalSync) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const PaywallPage()),
                                        );
                                        return;
                                      }
                                      _showImportDialog(context, room);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (e, s) => Center(
                      child: Text(e.toString(),
                          style: const TextStyle(color: NeoBrutalistTheme.grey))),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (e, s) => Center(
                    child: Text(e.toString(),
                        style: const TextStyle(color: NeoBrutalistTheme.grey))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImportDialog(BuildContext context, Room room) {
    final l10n = context.l10n;
    final urlController = TextEditingController();
    bool isImporting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: NeoBrutalistTheme.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
          ),
          title: Text(l10n.upper('calendarImportTitle'),
              style: NeoBrutalistTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.t('calendarImportDescription'),
                style: NeoBrutalistTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                style: NeoBrutalistTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: l10n.t('icalUrl'),
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
                  prefixIcon:
                      const Icon(Icons.link, color: NeoBrutalistTheme.blue),
                ),
              ),
              if (isImporting) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(color: NeoBrutalistTheme.blue),
                const SizedBox(height: 8),
                Text(l10n.t('importingProcessing'),
                    style: NeoBrutalistTheme.bodyMedium
                        .copyWith(color: NeoBrutalistTheme.grey)),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isImporting ? null : () => Navigator.pop(context),
              child: Text(l10n.upper('cancel'),
                  style: NeoBrutalistTheme.labelLarge
                      .copyWith(color: NeoBrutalistTheme.grey)),
            ),
            GestureDetector(
              onTap: isImporting
                  ? null
                  : () async {
                      final url = urlController.text.trim();
                      if (url.isNotEmpty) {
                        setState(() => isImporting = true);
                        try {
                          String source = 'external';
                          if (url.contains('airbnb'))
                            source = 'airbnb';
                          else if (url.contains('booking.com'))
                            source = 'booking_com';
                          else if (url.contains('expedia')) source = 'expedia';

                          final bookings = await icalImportServiceProvider
                              .fetchAndParseIcal(url, room);

                          int addedCount = 0;
                          int skippedCount = 0;

                          for (final booking in bookings) {
                            try {
                              final guestId =
                                  '${DateTime.now().millisecondsSinceEpoch}_$addedCount';
                              final hotelId =
                                  ref.read(appStateProvider).user?.hotelId ??
                                      '';
                              await ref
                                  .read(boutiFlowServiceProvider)
                                  .createGuest(
                                    hotelId: hotelId,
                                    id: guestId,
                                    name: booking.guest.name.isEmpty
                                        ? l10n.t('externalGuest')
                                        : booking.guest.name,
                                    languageCode: 'tr',
                                    notes: l10n.tf('importedFromIcalSource',
                                        {'source': source}),
                                  );

                              await ref
                                  .read(boutiFlowServiceProvider)
                                  .createBooking(
                                    hotelId: hotelId,
                                    roomId: booking.room.id,
                                    guestId: guestId,
                                    checkIn: booking.checkIn,
                                    checkOut: booking.checkOut,
                                    source: source,
                                    notes: booking.guest.notes,
                                  );
                              addedCount++;
                            } catch (e) {
                              skippedCount++;
                              debugPrint('Atlandı: $e');
                            }
                          }

                          ref.invalidate(bookingsProvider);
                          ref.invalidate(dashboardProvider);
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.tf('importSummary', {
                                    'added': addedCount,
                                    'skipped': skippedCount,
                                  }),
                                ),
                                backgroundColor: addedCount > 0
                                    ? NeoBrutalistTheme.green
                                    : NeoBrutalistTheme.orange,
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() => isImporting = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(l10n.tf('importFailed', {'error': e})),
                                backgroundColor: NeoBrutalistTheme.red));
                          }
                        }
                      }
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: NeoBrutalistTheme.cardDecoration(isImporting
                    ? NeoBrutalistTheme.grey
                    : NeoBrutalistTheme.green),
                child: Text(l10n.upper('importAction'),
                    style: NeoBrutalistTheme.labelLarge
                        .copyWith(color: NeoBrutalistTheme.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
