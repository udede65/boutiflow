import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/interstitial_ad_service.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../bookings/data/models/room_model.dart';
import '../bookings/presentation/providers/room_providers.dart';
import '../bookings/presentation/providers/booking_providers.dart';
import '../paywall/paywall_provider.dart';

class HousekeepingPage extends ConsumerStatefulWidget {
  const HousekeepingPage({super.key});

  @override
  ConsumerState<HousekeepingPage> createState() => _HousekeepingPageState();
}

class _HousekeepingPageState extends ConsumerState<HousekeepingPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomListProvider);
    final bookingsAsync = ref.watch(bookingListProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ===
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          size: 20, color: NeoBrutalistTheme.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    l10n.t('housekeeping').toUpperCase(),
                    style: NeoBrutalistTheme.headlineLarge,
                  ),
                ],
              ),
            ),

            // === FILTERS ===
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterChip('All', l10n, NeoBrutalistTheme.yellow),
                  const SizedBox(width: 8),
                  _buildFilterChip('Clean', l10n, NeoBrutalistTheme.green),
                  const SizedBox(width: 8),
                  _buildFilterChip('Dirty', l10n, NeoBrutalistTheme.red),
                  const SizedBox(width: 8),
                  _buildFilterChip('Occupied', l10n, NeoBrutalistTheme.blue),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // === LIST ===
            Expanded(
              child: roomsAsync.when(
                data: (rooms) => bookingsAsync.when(
                  data: (bookings) {
                    final filteredRooms = rooms.where((room) {
                      final isOccupied = _isRoomOccupied(room, bookings);

                      switch (_selectedFilter) {
                        case 'Clean':
                          return room.cleaningStatus == CleaningStatus.clean;
                        case 'Dirty':
                          return room.cleaningStatus == CleaningStatus.dirty;
                        case 'Occupied':
                          return isOccupied;
                        default:
                          return true;
                      }
                    }).toList();

                    if (filteredRooms.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: NeoBrutalistTheme.cardDecoration(
                                NeoBrutalistTheme.grey.withOpacity(0.2),
                              ),
                              child: const Icon(
                                Icons.cleaning_services_rounded,
                                size: 48,
                                color: NeoBrutalistTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.t('noRoomsFound'),
                              style: NeoBrutalistTheme.titleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      itemCount: filteredRooms.length,
                      itemBuilder: (context, index) {
                        final room = filteredRooms[index];
                        final isOccupied = _isRoomOccupied(room, bookings);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _RoomStatusCard(
                              room: room, isOccupied: isOccupied),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: NeoBrutalistTheme.black),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      l10n.tf('errorWithMessage', {'error': e}),
                      style: NeoBrutalistTheme.bodyLarge,
                    ),
                  ),
                ),
                loading: () => const Center(
                  child:
                      CircularProgressIndicator(color: NeoBrutalistTheme.black),
                ),
                error: (e, _) => Center(
                  child: Text(
                    l10n.tf('errorWithMessage', {'error': e}),
                    style: NeoBrutalistTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // === FAB: Add Room ===
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRoomDialog(context, ref),
        backgroundColor: NeoBrutalistTheme.yellow,
        foregroundColor: NeoBrutalistTheme.black,
        icon: const Icon(Icons.add),
        label: Text(l10n.upper('addRoom')),
      ),
    );
  }

  Widget _buildFilterChip(
      String filter, AppLocalizations l10n, Color activeColor) {
    final isSelected = _selectedFilter == filter;
    String label = filter;
    if (filter == 'All') label = l10n.t('all');
    if (filter == 'Clean') label = l10n.t('clean');
    if (filter == 'Dirty') label = l10n.t('dirty');
    if (filter == 'Occupied') label = l10n.t('occupied');

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : NeoBrutalistTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NeoBrutalistTheme.black, width: 2),
          boxShadow: isSelected ? NeoBrutalistTheme.brutalistShadowSmall : null,
        ),
        child: Text(
          label.toUpperCase(),
          style: NeoBrutalistTheme.labelLarge.copyWith(
            color:
                isSelected ? NeoBrutalistTheme.black : NeoBrutalistTheme.grey,
          ),
        ),
      ),
    );
  }

  bool _isRoomOccupied(RoomModel room, List<dynamic> bookings) {
    final now = DateTime.now();
    return bookings.any((b) =>
        b.roomId == room.id &&
        b.status.name != 'cancelled' &&
        b.status.name != 'checkedOut' &&
        (b.checkIn.isBefore(now) || b.checkIn.isAtSameMomentAs(now)) &&
        b.checkOut.isAfter(now));
  }

  void _showAddRoomDialog(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nameController = TextEditingController();
    RoomType selectedType = RoomType.room;
    final priceController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: NeoBrutalistTheme.cream,
          title: Text(l10n.t('addRoom'), style: NeoBrutalistTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.t('roomName'),
                  hintText: l10n.t('roomNameExample'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RoomType>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: l10n.t('roomType'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: RoomType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedType = value!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.t('defaultPrice'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.t('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoBrutalistTheme.green,
                foregroundColor: NeoBrutalistTheme.white,
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final price = double.tryParse(priceController.text) ?? 0;

                await ref.read(roomControllerProvider.notifier).addRoom(
                      name: name,
                      type: selectedType,
                      defaultPrice: price,
                    );

                // Show interstitial ad for free users
                if (!ref.read(isProProvider)) {
                  InterstitialAdService.instance.showAd();
                }

                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.t('add')),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomStatusCard extends ConsumerWidget {
  const _RoomStatusCard({required this.room, required this.isOccupied});

  final RoomModel room;
  final bool isOccupied;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // Parse color from hex
    Color roomColor;
    try {
      roomColor = Color(int.parse(room.colorCode.replaceFirst('#', '0xFF')));
    } catch (_) {
      roomColor = NeoBrutalistTheme.blue;
    }

    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (room.cleaningStatus) {
      case CleaningStatus.clean:
        statusColor = NeoBrutalistTheme.green;
        statusIcon = Icons.check_circle_rounded;
        statusLabel = l10n.t('clean');
        break;
      case CleaningStatus.dirty:
        statusColor = NeoBrutalistTheme.red;
        statusIcon = Icons.cleaning_services_rounded;
        statusLabel = l10n.t('dirty');
        break;
    }

    return GestureDetector(
      onLongPress: () => _toggleCleaningStatus(ref),
      child: NeoCard(
        color: NeoBrutalistTheme.white,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            // Color stripe from room.color_code
            Container(
              width: 8,
              height: 88,
              decoration: BoxDecoration(
                color: roomColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Status Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: NeoBrutalistTheme.black, width: 2),
              ),
              child: Icon(statusIcon, color: NeoBrutalistTheme.white, size: 28),
            ),
            const SizedBox(width: 16),

            // Room Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(room.name, style: NeoBrutalistTheme.titleMedium),
                        if (isOccupied) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: NeoBrutalistTheme.blue,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: NeoBrutalistTheme.black, width: 1),
                            ),
                            child: Text(
                              l10n.upper('occupied'),
                              style: NeoBrutalistTheme.labelLarge.copyWith(
                                color: NeoBrutalistTheme.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          statusLabel,
                          style: NeoBrutalistTheme.bodyMedium
                              .copyWith(color: statusColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${room.type.name.toUpperCase()}',
                          style: NeoBrutalistTheme.bodyMedium.copyWith(
                            color: NeoBrutalistTheme.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action Menu
            PopupMenuButton<CleaningStatus>(
              icon: const Icon(Icons.more_vert, color: NeoBrutalistTheme.black),
              onSelected: (CleaningStatus newStatus) {
                ref.read(roomControllerProvider.notifier).updateCleaningStatus(
                      room.id,
                      newStatus,
                    );
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<CleaningStatus>>[
                PopupMenuItem<CleaningStatus>(
                  value: CleaningStatus.clean,
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: NeoBrutalistTheme.green),
                      const SizedBox(width: 8),
                      Text(l10n.t('markClean')),
                    ],
                  ),
                ),
                PopupMenuItem<CleaningStatus>(
                  value: CleaningStatus.dirty,
                  child: Row(
                    children: [
                      const Icon(Icons.cleaning_services_rounded,
                          color: NeoBrutalistTheme.red),
                      const SizedBox(width: 8),
                      Text(l10n.t('markDirty')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _toggleCleaningStatus(WidgetRef ref) {
    final newStatus = room.cleaningStatus == CleaningStatus.clean
        ? CleaningStatus.dirty
        : CleaningStatus.clean;

    ref.read(roomControllerProvider.notifier).updateCleaningStatus(
          room.id,
          newStatus,
        );
  }
}
