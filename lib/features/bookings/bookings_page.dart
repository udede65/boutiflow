import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../providers/booking_providers.dart';
import '../../state/app_state.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class BookingsPage extends ConsumerWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bookingsAsync = ref.watch(bookingsProvider);
    final currencySymbol =
        getCurrencySymbol(ref.watch(appStateProvider).user?.currency ?? 'EUR');

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: Column(
          children: [
            // === HEADER ===
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.t('bookings').toUpperCase(),
                    style: NeoBrutalistTheme.headlineLarge,
                  ),
                  GestureDetector(
                    onTap: () => context.push('/bookings/add'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: NeoBrutalistTheme.cardDecoration(
                          NeoBrutalistTheme.blue),
                      child: const Icon(
                        Icons.add_rounded,
                        color: NeoBrutalistTheme.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // === CONTENT ===
            Expanded(
              child: bookingsAsync.when(
                data: (bookings) {
                  if (bookings.isEmpty) {
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
                              Icons.event_busy_rounded,
                              size: 48,
                              color: NeoBrutalistTheme.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.t('noBookingsYet'),
                            style: NeoBrutalistTheme.titleMedium,
                          ),
                          const SizedBox(height: 24),
                          NeoButton(
                            text: l10n.upper('addBooking'),
                            onPressed: () => context.push('/bookings/add'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _BookingCard(
                          booking: booking,
                          currencySymbol: currencySymbol,
                          l10n: l10n,
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child:
                      CircularProgressIndicator(color: NeoBrutalistTheme.black),
                ),
                error: (error, _) => Center(
                  child: Text(
                    l10n.tf('errorWithMessage', {'error': error}),
                    style: NeoBrutalistTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.currencySymbol,
    required this.l10n,
  });

  final Booking booking;
  final String currencySymbol;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/bookings/${booking.id}', extra: booking),
      child: NeoCard(
        color: NeoBrutalistTheme.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _getStatusColor(booking.status),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: NeoBrutalistTheme.black, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    '${booking.checkIn.day}',
                    style: NeoBrutalistTheme.titleLarge.copyWith(
                      color: NeoBrutalistTheme.white,
                    ),
                  ),
                  Text(
                    _monthName(context, booking.checkIn),
                    style: NeoBrutalistTheme.labelLarge.copyWith(
                      color: NeoBrutalistTheme.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.guest.name,
                    style: NeoBrutalistTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.bed_rounded,
                          size: 14, color: NeoBrutalistTheme.grey),
                      const SizedBox(width: 4),
                      Text(
                        booking.room.name,
                        style: NeoBrutalistTheme.bodyMedium
                            .copyWith(color: NeoBrutalistTheme.grey),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: NeoBrutalistTheme.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _sourceLabel(booking.source, l10n),
                          style: NeoBrutalistTheme.labelLarge.copyWith(
                            fontSize: 10,
                            color: NeoBrutalistTheme.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (booking.isHourly)
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 14, color: NeoBrutalistTheme.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${booking.checkIn.hour.toString().padLeft(2, '0')}:${booking.checkIn.minute.toString().padLeft(2, '0')} - ${booking.checkOut.hour.toString().padLeft(2, '0')}:${booking.checkOut.minute.toString().padLeft(2, '0')}',
                          style: NeoBrutalistTheme.bodyMedium.copyWith(
                            color: NeoBrutalistTheme.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NeoBrutalistTheme.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: NeoBrutalistTheme.orange.withOpacity(0.3),
                                width: 1),
                          ),
                          child: Text(
                            l10n.t('hourlyBooking').toUpperCase(),
                            style: NeoBrutalistTheme.labelLarge.copyWith(
                              fontSize: 9,
                              color: NeoBrutalistTheme.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            size: 14, color: NeoBrutalistTheme.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(booking.checkIn)} - ${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(booking.checkOut)}',
                          style: NeoBrutalistTheme.bodyMedium
                              .copyWith(color: NeoBrutalistTheme.grey),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Price & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(booking.priceTotal ?? 0.0).toStringAsFixed(0)} $currencySymbol',
                  style: NeoBrutalistTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _StatusChip(status: booking.status, l10n: l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.reserved:
        return NeoBrutalistTheme.blue;
      case BookingStatus.checkedIn:
        return NeoBrutalistTheme.green;
      case BookingStatus.checkedOut:
        return NeoBrutalistTheme.grey;
      case BookingStatus.cancelled:
        return NeoBrutalistTheme.red;
    }
  }

  String _sourceLabel(String source, AppLocalizations l10n) {
    switch (source) {
      case 'direct':
        return l10n.t('sourceDirect');
      case 'airbnb':
        return l10n.t('sourceAirbnb');
      case 'booking_com':
        return l10n.t('sourceBookingCom');
      case 'expedia':
        return l10n.t('sourceExpedia');
      default:
        return source;
    }
  }

  String _monthName(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat.MMM(locale).format(date);
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.l10n});

  final BookingStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case BookingStatus.reserved:
        color = NeoBrutalistTheme.blue;
        label = l10n.t('reserved');
        break;
      case BookingStatus.checkedIn:
        color = NeoBrutalistTheme.green;
        label = l10n.t('checkedIn');
        break;
      case BookingStatus.checkedOut:
        color = NeoBrutalistTheme.grey;
        label = l10n.t('checkedOut');
        break;
      case BookingStatus.cancelled:
        color = NeoBrutalistTheme.red;
        label = l10n.t('cancelled');
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: NeoBrutalistTheme.black, width: 1.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: NeoBrutalistTheme.labelLarge.copyWith(
          fontSize: 10,
          color: NeoBrutalistTheme.white,
        ),
      ),
    );
  }
}
