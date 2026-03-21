import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../core/models/entities.dart';

class NotificationService {
  final fln.FlutterLocalNotificationsPlugin _notificationsPlugin = fln.FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    const fln.DarwinInitializationSettings initializationSettingsIOS =
        fln.DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const fln.InitializationSettings initializationSettings = fln.InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<fln.IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<fln.AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleBookingNotifications(Booking booking) async {
    if (booking.status == BookingStatus.cancelled) {
      await cancelNotificationsForBooking(booking.id);
      return;
    }

    // Check-in Reminder (Day of check-in at 09:00 AM)
    final checkInDate = DateTime(
      booking.checkIn.year,
      booking.checkIn.month,
      booking.checkIn.day,
      9, 0, 0,
    );
    
    if (checkInDate.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: booking.id.hashCode,
        title: 'Check-in Today: ${booking.guest.name}',
        body: 'Room: ${booking.room.name}',
        scheduledDate: checkInDate,
      );
    }

    // Check-out Reminder (Day of check-out at 10:00 AM)
    final checkOutDate = DateTime(
      booking.checkOut.year,
      booking.checkOut.month,
      booking.checkOut.day,
      10, 0, 0,
    );

    if (checkOutDate.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: booking.id.hashCode + 1,
        title: 'Check-out Today: ${booking.guest.name}',
        body: 'Room: ${booking.room.name}. Please verify payment.',
        scheduledDate: checkOutDate,
      );
    }
  }

  Future<void> cancelNotificationsForBooking(String bookingId) async {
    await _notificationsPlugin.cancel(bookingId.hashCode);
    await _notificationsPlugin.cancel(bookingId.hashCode + 1);
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'booking_reminders',
          'Booking Reminders',
          channelDescription: 'Notifications for check-in and check-out events',
          importance: fln.Importance.max,
          priority: fln.Priority.high,
        ),
        iOS: fln.DarwinNotificationDetails(),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

final notificationServiceProvider = NotificationService();
