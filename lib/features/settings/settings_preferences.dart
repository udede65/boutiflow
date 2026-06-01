import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class SettingsPreferencesList extends StatelessWidget {
  const SettingsPreferencesList({
    super.key,
    required this.languageLabel,
    required this.isPremium,
    required this.dailyBookingNotificationsEnabled,
    required this.backupRemindersEnabled,
    required this.onLanguageTap,
    required this.onDailyBookingNotificationsChanged,
    required this.onBackupRemindersChanged,
    required this.onBackupRemindersUpgrade,
  });

  final String languageLabel;
  final bool isPremium;
  final bool dailyBookingNotificationsEnabled;
  final bool backupRemindersEnabled;
  final VoidCallback onLanguageTap;
  final ValueChanged<bool> onDailyBookingNotificationsChanged;
  final ValueChanged<bool> onBackupRemindersChanged;
  final VoidCallback onBackupRemindersUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const textPrimary = NeoBrutalistTheme.black;
    const textSecondary = NeoBrutalistTheme.grey;
    const textMuted = NeoBrutalistTheme.grey;
    const primary = NeoBrutalistTheme.blue;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.language_rounded, color: textSecondary),
          title: Text(l10n.t('language'),
              style: GoogleFonts.inter(color: textPrimary)),
          subtitle: Text(
            '$languageLabel • ${l10n.t('languageManagementHint')}',
            style: GoogleFonts.inter(color: textMuted),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: textMuted),
          onTap: onLanguageTap,
        ),
        SwitchListTile(
          secondary:
              const Icon(Icons.event_available_rounded, color: textSecondary),
          title: Text(l10n.t('dailyBookingNotifications'),
              style: GoogleFonts.inter(color: textPrimary)),
          subtitle: Text(l10n.t('dailyBookingNotificationsSubtitle'),
              style: GoogleFonts.inter(color: textMuted)),
          value: dailyBookingNotificationsEnabled,
          activeThumbColor: primary,
          onChanged: onDailyBookingNotificationsChanged,
        ),
        if (isPremium)
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_rounded,
                color: textSecondary),
            title: Text(l10n.t('backupReminders'),
                style: GoogleFonts.inter(color: textPrimary)),
            subtitle: Text(l10n.t('backupRemindersSubtitle'),
                style: GoogleFonts.inter(color: textMuted)),
            value: backupRemindersEnabled,
            activeThumbColor: primary,
            onChanged: onBackupRemindersChanged,
          )
        else
          ListTile(
            leading: const Icon(Icons.lock_clock_rounded, color: primary),
            title: Text(l10n.t('backupReminders'),
                style: GoogleFonts.inter(color: textPrimary)),
            subtitle: Text(l10n.t('backupRemindersPremiumSubtitle'),
                style: GoogleFonts.inter(color: textMuted)),
            trailing: _PremiumBadge(label: l10n.t('premium')),
            onTap: onBackupRemindersUpgrade,
          ),
      ],
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: NeoBrutalistTheme.yellow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NeoBrutalistTheme.black, width: 2),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: NeoBrutalistTheme.black,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
