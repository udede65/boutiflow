import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferenceState {
  const NotificationPreferenceState({
    required this.dailyBookingNotificationsEnabled,
    required this.backupRemindersEnabled,
    required this.lastBackupAt,
  });

  final bool dailyBookingNotificationsEnabled;
  final bool backupRemindersEnabled;
  final DateTime? lastBackupAt;

  bool get hasEnabledNotifications =>
      dailyBookingNotificationsEnabled || backupRemindersEnabled;
}

class NotificationPreferences {
  static const _dailyBookingNotificationsKey =
      'daily_booking_notifications_enabled';
  static const _backupRemindersKey = 'backup_reminders_enabled';
  static const _lastBackupAtKey = 'last_backup_completed_at';

  static Future<NotificationPreferenceState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final lastBackupMillis = prefs.getInt(_lastBackupAtKey);

    return NotificationPreferenceState(
      dailyBookingNotificationsEnabled:
          prefs.getBool(_dailyBookingNotificationsKey) ?? true,
      backupRemindersEnabled: prefs.getBool(_backupRemindersKey) ?? true,
      lastBackupAt: lastBackupMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastBackupMillis),
    );
  }

  static Future<void> setDailyBookingNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dailyBookingNotificationsKey, enabled);
  }

  static Future<void> setBackupRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backupRemindersKey, enabled);
  }

  static Future<void> setAllNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(_dailyBookingNotificationsKey, enabled),
      prefs.setBool(_backupRemindersKey, enabled),
    ]);
  }

  static Future<void> markBackupCompleted([DateTime? completedAt]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _lastBackupAtKey,
      (completedAt ?? DateTime.now()).millisecondsSinceEpoch,
    );
  }
}
