import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/services/notification_plan.dart';

void main() {
  test('builds one daily summary at 09:00 only for days with movement', () {
    final plan = buildNotificationRefreshPlan(
      bookings: [
        _booking(
          id: 'a',
          guestName: 'Zeynep',
          checkIn: DateTime(2026, 5, 18),
          checkOut: DateTime(2026, 5, 20),
        ),
        _booking(
          id: 'b',
          guestName: 'Umut',
          checkIn: DateTime(2026, 5, 18),
          checkOut: DateTime(2026, 5, 19),
        ),
      ],
      now: DateTime(2026, 5, 18, 8),
      languageCode: 'tr',
      dailyBookingNotificationsEnabled: true,
      backupRemindersEnabled: false,
      lastBackupAt: null,
    );

    expect(plan.cancelExisting, isTrue);
    expect(plan.requests.map((request) => request.scheduledAt), [
      DateTime(2026, 5, 18, 9),
      DateTime(2026, 5, 19, 9),
      DateTime(2026, 5, 20, 9),
    ]);
    expect(plan.requests.first.body, 'Bugünkü plan: 2 giriş, 0 çıkış');
    expect(plan.requests[1].body, 'Bugünkü plan: 0 giriş, 1 çıkış');
    expect(plan.requests[2].body, 'Bugünkü plan: 0 giriş, 1 çıkış');
  });

  test('backup reminders are scheduled weekly at 09:15', () {
    final requests = buildWeeklyBackupReminderRequests(
      now: DateTime(2026, 5, 18, 10),
      languageCode: 'en',
      enabled: true,
      lastBackupAt: DateTime(2026, 5, 10, 9),
    );

    expect(
      requests.map((request) => request.scheduledAt),
      [
        DateTime(2026, 5, 24, 9, 15),
        DateTime(2026, 5, 31, 9, 15),
      ],
    );
    expect(requests.first.title, 'Backup reminder');
  });

  test('backup reminders keep the same weekly day when plan refreshes daily',
      () {
    final mondayRequests = buildWeeklyBackupReminderRequests(
      now: DateTime(2026, 5, 18, 10),
      languageCode: 'en',
      enabled: true,
      lastBackupAt: null,
    );
    final tuesdayRequests = buildWeeklyBackupReminderRequests(
      now: DateTime(2026, 5, 19, 10),
      languageCode: 'en',
      enabled: true,
      lastBackupAt: null,
    );

    expect(mondayRequests.first.scheduledAt, DateTime(2026, 5, 25, 9, 15));
    expect(tuesdayRequests.first.scheduledAt, DateTime(2026, 5, 25, 9, 15));
  });
}

Booking _booking({
  required String id,
  required String guestName,
  required DateTime checkIn,
  required DateTime checkOut,
}) {
  return Booking(
    id: id,
    room: const Room(
      id: 'room-1',
      name: 'Oda 1',
      capacity: 2,
      status: RoomStatus.clean,
    ),
    guest: Guest(id: 'guest-$id', name: guestName, languageCode: 'tr'),
    checkIn: checkIn,
    checkOut: checkOut,
  );
}
