import 'package:flutter/widgets.dart';

import '../core/localization/app_localizations.dart';
import '../core/models/entities.dart';

const dailySummaryNotificationBaseId = 810000;
const backupReminderNotificationId = 820000;
const notificationPlanningWindowDays = 14;

class ScheduledNotificationRequest {
  const ScheduledNotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;
}

class NotificationRefreshPlan {
  const NotificationRefreshPlan({
    required this.cancelExisting,
    required this.requests,
  });

  final bool cancelExisting;
  final List<ScheduledNotificationRequest> requests;
}

NotificationRefreshPlan buildNotificationRefreshPlan({
  required List<Booking> bookings,
  required DateTime now,
  required String languageCode,
  required bool dailyBookingNotificationsEnabled,
  required bool backupRemindersEnabled,
  required DateTime? lastBackupAt,
}) {
  final requests = <ScheduledNotificationRequest>[
    if (dailyBookingNotificationsEnabled)
      ...buildDailyBookingSummaryRequests(
        bookings: bookings,
        now: now,
        languageCode: languageCode,
      ),
    if (backupRemindersEnabled)
      ...buildWeeklyBackupReminderRequests(
        now: now,
        languageCode: languageCode,
        enabled: true,
        lastBackupAt: lastBackupAt,
      ),
  ];

  return NotificationRefreshPlan(cancelExisting: true, requests: requests);
}

List<ScheduledNotificationRequest> buildDailyBookingSummaryRequests({
  required List<Booking> bookings,
  required DateTime now,
  required String languageCode,
}) {
  final l10n = AppLocalizations(Locale(_safeLanguageCode(languageCode)));
  final start = _startOfDay(now);
  final requests = <ScheduledNotificationRequest>[];

  for (var offset = 0; offset < notificationPlanningWindowDays; offset++) {
    final day = start.add(Duration(days: offset));
    final scheduledAt = DateTime(day.year, day.month, day.day, 9);
    if (!scheduledAt.isAfter(now)) continue;

    final checkIns = bookings
        .where((booking) =>
            booking.status != BookingStatus.cancelled &&
            _isSameDay(booking.checkIn, day))
        .length;
    final checkOuts = bookings
        .where((booking) =>
            booking.status != BookingStatus.cancelled &&
            _isSameDay(booking.checkOut, day))
        .length;

    if (checkIns == 0 && checkOuts == 0) continue;

    requests.add(
      ScheduledNotificationRequest(
        id: dailySummaryNotificationBaseId + offset,
        title: l10n.t('dailyBookingNotificationTitle'),
        body: l10n.tf('dailyBookingNotificationBody', {
          'checkIns': checkIns,
          'checkOuts': checkOuts,
        }),
        scheduledAt: scheduledAt,
      ),
    );
  }

  return requests;
}

ScheduledNotificationRequest? buildBackupReminderRequest({
  required DateTime now,
  required String languageCode,
  required bool enabled,
  required DateTime? lastBackupAt,
}) {
  final requests = buildWeeklyBackupReminderRequests(
    now: now,
    languageCode: languageCode,
    enabled: enabled,
    lastBackupAt: lastBackupAt,
  );
  return requests.isEmpty ? null : requests.first;
}

List<ScheduledNotificationRequest> buildWeeklyBackupReminderRequests({
  required DateTime now,
  required String languageCode,
  required bool enabled,
  required DateTime? lastBackupAt,
}) {
  if (!enabled) return const [];
  final l10n = AppLocalizations(Locale(_safeLanguageCode(languageCode)));
  final windowEnd =
      now.add(const Duration(days: notificationPlanningWindowDays));
  var scheduledAt = _nextWeeklyBackupTime(now, lastBackupAt);
  final requests = <ScheduledNotificationRequest>[];

  while (!scheduledAt.isAfter(windowEnd)) {
    requests.add(
      ScheduledNotificationRequest(
        id: backupReminderNotificationId + requests.length,
        title: l10n.t('backupNotificationTitle'),
        body: l10n.t('backupNotificationBody'),
        scheduledAt: scheduledAt,
      ),
    );
    scheduledAt = scheduledAt.add(const Duration(days: 7));
  }

  return requests;
}

DateTime _nextWeeklyBackupTime(DateTime now, DateTime? lastBackupAt) {
  final targetWeekday = lastBackupAt?.weekday ?? DateTime.monday;
  var daysUntilTarget = targetWeekday - now.weekday;
  if (daysUntilTarget < 0) daysUntilTarget += 7;

  var targetDay = now.add(Duration(days: daysUntilTarget));
  var next = DateTime(targetDay.year, targetDay.month, targetDay.day, 9, 15);
  if (!next.isAfter(now)) {
    targetDay = targetDay.add(const Duration(days: 7));
    next = DateTime(targetDay.year, targetDay.month, targetDay.day, 9, 15);
  }

  if (lastBackupAt != null) {
    final earliest = DateTime(
      lastBackupAt.year,
      lastBackupAt.month,
      lastBackupAt.day,
      9,
      15,
    ).add(const Duration(days: 7));
    while (next.isBefore(earliest) || !next.isAfter(now)) {
      next = next.add(const Duration(days: 7));
    }
  }

  return next;
}

DateTime _startOfDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _safeLanguageCode(String languageCode) {
  if (supportedLanguageCodes.contains(languageCode)) return languageCode;
  return 'en';
}
