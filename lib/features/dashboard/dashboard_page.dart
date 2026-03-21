import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/booking_providers.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final summaryAsync = ref.watch(dashboardProvider);
    final user = ref.watch(appStateProvider).user;

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: summaryAsync.when(
          data: (data) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === HEADER ===
                _buildHeader(user?.hotelName ?? 'BoutiFlow', l10n),
                const SizedBox(height: 24),

                // === ADD BOOKING BUTTON ===
                SizedBox(
                  width: double.infinity,
                  child: NeoButton(
                    text: '+ ${l10n.t('addBooking')}',
                    icon: Icons.add,
                    onPressed: () => context.push('/bookings/add'),
                  ),
                ),
                const SizedBox(height: 24),

                // === STAT CARDS GRID ===
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NeoStatCard(
                          color: NeoBrutalistTheme.blue,
                          icon: Icons.login_rounded,
                          value: '${data.todayCheckIns.length}',
                          label: l10n.t('todayCheckIn'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NeoStatCard(
                          color: NeoBrutalistTheme.red,
                          icon: Icons.logout_rounded,
                          value: '${data.todayCheckOuts.length}',
                          label: l10n.t('todayCheckOut'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NeoStatCard(
                          color: NeoBrutalistTheme.green,
                          icon: Icons.percent_rounded,
                          value: '${data.occupancy.toStringAsFixed(0)}%',
                          label: l10n.t('occupancy'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NeoStatCard(
                          color: NeoBrutalistTheme.purple,
                          icon: Icons.calendar_today_rounded,
                          value: '${data.upcoming.length}',
                          label: l10n.t('upcoming'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // === QUICK ACTIONS ===
                Text(
                  l10n.upper('quickActions'),
                  style: NeoBrutalistTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildQuickActionsGrid(context, l10n),

                const SizedBox(height: 24),

                // === UPCOMING BOOKINGS ===
                _buildUpcomingSection(context, l10n, data),

                const SizedBox(height: 100), // Bottom padding for nav bar
              ],
            ),
          ),
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: NeoBrutalistTheme.black,
                  strokeWidth: 4,
                ),
                const SizedBox(height: 16),
                Text(l10n.t('loading'), style: NeoBrutalistTheme.titleMedium),
              ],
            ),
          ),
          error: (err, _) => Center(
            child: NeoCard(
              color: NeoBrutalistTheme.red,
              child: Text(
                'Error: $err',
                style: NeoBrutalistTheme.bodyLargeWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String hotelName, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.upperText(hotelName),
                style: NeoBrutalistTheme.headlineLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getGreeting(l10n),
                style: NeoBrutalistTheme.bodyLarge.copyWith(
                  color: NeoBrutalistTheme.grey,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration:
              NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.yellow),
          child: const Icon(
            Icons.hotel_rounded,
            color: NeoBrutalistTheme.black,
            size: 28,
          ),
        ),
      ],
    );
  }

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return l10n.t('morning');
    if (hour >= 12 && hour < 18) return l10n.t('afternoon');
    if (hour >= 18 && hour < 22) return l10n.t('evening');
    return l10n.t('night');
  }

  Widget _buildQuickActionsGrid(BuildContext context, AppLocalizations l10n) {
    final actions = [
      _QuickAction(
        icon: Icons.calendar_month_rounded,
        label: l10n.t('calendar'),
        color: NeoBrutalistTheme.orange,
        route: '/calendar',
        push: false, // tab route
      ),
      _QuickAction(
        icon: Icons.people_rounded,
        label: l10n.t('guests'),
        color: NeoBrutalistTheme.cyan,
        route: '/guests',
        push: false, // tab route
      ),
      _QuickAction(
        icon: Icons.cleaning_services_rounded,
        label: l10n.t('housekeeping'),
        color: NeoBrutalistTheme.pink,
        route: '/housekeeping',
        push: true, // non-tab: push so back button works
      ),
      _QuickAction(
        icon: Icons.settings_rounded,
        label: l10n.t('settings'),
        color: NeoBrutalistTheme.grey,
        route: '/settings',
        push: false, // tab route
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: () => action.push ? context.push(action.route) : context.go(action.route),
          child: Container(
            decoration: NeoBrutalistTheme.cardDecoration(action.color),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action.icon, color: NeoBrutalistTheme.white, size: 28),
                const SizedBox(height: 8),
                Text(
                  action.label,
                  style: NeoBrutalistTheme.labelLarge.copyWith(
                    color: NeoBrutalistTheme.white,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpcomingSection(
      BuildContext context, AppLocalizations l10n, dynamic data) {
    final titleText = l10n.upper('upcomingBookings');
    final viewAllText = l10n.upper('viewAll');
    final titleStyle = NeoBrutalistTheme.headlineMedium;
    final viewAllStyle = NeoBrutalistTheme.labelLarge.copyWith(fontSize: 12);

    final viewAllButton = GestureDetector(
      onTap: () => context.go('/bookings'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: NeoBrutalistTheme.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NeoBrutalistTheme.black, width: 2),
        ),
        child: Text(
          viewAllText,
          style: viewAllStyle,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final textScaler = MediaQuery.textScalerOf(context);
            final textDirection = Directionality.of(context);
            final titlePainter = TextPainter(
              text: TextSpan(text: titleText, style: titleStyle),
              textDirection: textDirection,
              textScaler: textScaler,
              maxLines: 1,
            )..layout();
            final buttonPainter = TextPainter(
              text: TextSpan(text: viewAllText, style: viewAllStyle),
              textDirection: textDirection,
              textScaler: textScaler,
              maxLines: 1,
            )..layout();

            // Keep the title fully visible by stacking when one-row space is not enough.
            final buttonEstimatedWidth = buttonPainter.width + 28;
            final needsStackedHeader =
                titlePainter.width + buttonEstimatedWidth + 12 >
                    constraints.maxWidth;

            final title = Text(
              titleText,
              style: titleStyle,
            );

            if (needsStackedHeader) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: viewAllButton,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: title),
                const SizedBox(width: 12),
                viewAllButton,
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // Upcoming bookings list
        if (data.upcoming.isEmpty)
          NeoCard(
            color: NeoBrutalistTheme.white,
            child: Row(
              children: [
                const Icon(Icons.event_available,
                    color: NeoBrutalistTheme.grey),
                const SizedBox(width: 12),
                Text(
                  l10n.t('noUpcomingBookings'),
                  style: NeoBrutalistTheme.bodyLarge,
                ),
              ],
            ),
          )
        else
          ...data.upcoming.take(3).map<Widget>((booking) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildBookingCard(booking, l10n),
            );
          }),
      ],
    );
  }

  Widget _buildBookingCard(dynamic booking, AppLocalizations l10n) {
    final guestName = _getBookingGuestName(booking) ?? l10n.t('guest');
    final roomName = _getBookingRoomName(booking) ?? l10n.t('room');
    final statusCode = _normalizeStatus(booking.status);

    return NeoCard(
      color: NeoBrutalistTheme.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: NeoBrutalistTheme.blue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NeoBrutalistTheme.black, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${booking.checkIn.day}',
                  style: NeoBrutalistTheme.titleLarge.copyWith(
                    color: NeoBrutalistTheme.white,
                  ),
                ),
                Text(
                  _getMonthAbbr(booking.checkIn.month),
                  style: NeoBrutalistTheme.labelLarge.copyWith(
                    color: NeoBrutalistTheme.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guestName,
                  style: NeoBrutalistTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  roomName,
                  style: NeoBrutalistTheme.bodyMedium.copyWith(
                    color: NeoBrutalistTheme.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(statusCode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: NeoBrutalistTheme.black, width: 2),
            ),
            child: Text(
              _getStatusText(statusCode, l10n),
              style: NeoBrutalistTheme.labelLarge.copyWith(
                color: NeoBrutalistTheme.white,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  String? _getBookingGuestName(dynamic booking) {
    try {
      final dynamic nestedGuest = booking.guest;
      final dynamic nestedName = nestedGuest?.name;
      if (nestedName is String && nestedName.isNotEmpty) {
        return nestedName;
      }
    } catch (_) {}

    try {
      final dynamic guestName = booking.guestName;
      if (guestName is String && guestName.isNotEmpty) {
        return guestName;
      }
    } catch (_) {}

    return null;
  }

  String? _getBookingRoomName(dynamic booking) {
    try {
      final dynamic nestedRoom = booking.room;
      final dynamic nestedName = nestedRoom?.name;
      if (nestedName is String && nestedName.isNotEmpty) {
        return nestedName;
      }
    } catch (_) {}

    try {
      final dynamic roomName = booking.roomName;
      if (roomName is String && roomName.isNotEmpty) {
        return roomName;
      }
    } catch (_) {}

    return null;
  }

  String? _normalizeStatus(dynamic status) {
    if (status == null) return null;
    if (status is String) return status;

    final raw = status.toString();
    if (raw.contains('.')) {
      return raw.split('.').last;
    }
    return raw;
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'confirmed':
        return NeoBrutalistTheme.green;
      case 'pending':
        return NeoBrutalistTheme.orange;
      case 'checked_in':
      case 'checkedIn':
        return NeoBrutalistTheme.blue;
      case 'reserved':
        return NeoBrutalistTheme.blue;
      case 'checkedOut':
      case 'checked_out':
        return NeoBrutalistTheme.grey;
      case 'cancelled':
        return NeoBrutalistTheme.red;
      default:
        return NeoBrutalistTheme.grey;
    }
  }

  String _getStatusText(String? status, AppLocalizations l10n) {
    switch (status) {
      case 'confirmed':
        return l10n.t('confirmed');
      case 'pending':
        return l10n.t('pending');
      case 'checked_in':
      case 'checkedIn':
        return l10n.t('checkedIn');
      case 'reserved':
        return l10n.t('reserved');
      case 'checkedOut':
      case 'checked_out':
        return l10n.t('checkedOut');
      case 'cancelled':
        return l10n.t('cancelled');
      default:
        return l10n.t('status');
    }
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  final bool push;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.push = false,
  });
}
