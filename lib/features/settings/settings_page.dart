import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../state/app_state.dart';
import '../../services/providers.dart';
import '../../core/widgets/premium_gate.dart';
import '../../providers/booking_providers.dart';
import '../../core/services/plan_limits.dart';
import '../../core/widgets/upgrade_prompt.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import 'account_deletion_request.dart';
import 'legal_page_links.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final appState = ref.watch(appStateProvider);
    final user = appState.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final roomsAsync = ref.watch(roomsProvider);

    // Neo-Brutalist colors
    const textPrimary = NeoBrutalistTheme.black;
    const textSecondary = NeoBrutalistTheme.grey;
    const textMuted = NeoBrutalistTheme.grey;
    const inputBg = NeoBrutalistTheme.white;
    const inputBorder = NeoBrutalistTheme.black;
    final borderColor = NeoBrutalistTheme.black.withValues(alpha: 0.1);
    const primary = NeoBrutalistTheme.blue;
    final supportedLanguageNames =
        supportedLanguageCodes.map(AppLocalizations.languageLabel).join(' • ');

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
                children: [
                  Text(
                    l10n.upper('settings'),
                    style: NeoBrutalistTheme.headlineLarge,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 100), // Add bottom padding for nav bar
                children: [
                  // Hotel Profile Section
                  _SectionHeader(title: l10n.t('hotelProfile')),
                  NeoCard(
                    color: NeoBrutalistTheme.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: user.hotelName,
                          style: GoogleFonts.inter(color: textPrimary),
                          decoration: InputDecoration(
                            labelText: l10n.t('hotelName'),
                            labelStyle: TextStyle(color: textSecondary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: inputBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primary),
                            ),
                            filled: true,
                            fillColor: inputBg,
                          ),
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty) {
                              ref
                                  .read(boutiFlowServiceProvider)
                                  .updateHotelProfile(
                                    name: value,
                                    languageCode: user.languageCode,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.t('saved'))),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: user.currency,
                          style: GoogleFonts.inter(color: textPrimary),
                          decoration: InputDecoration(
                            labelText: l10n.t('currency'),
                            labelStyle: TextStyle(color: textSecondary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: inputBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primary),
                            ),
                            filled: true,
                            fillColor: inputBg,
                          ),
                          items:
                              ['EUR', 'USD', 'TRY', 'GBP', 'RUB'].map((code) {
                            return DropdownMenuItem(
                              value: code,
                              child: Text(code),
                            );
                          }).toList(),
                          onChanged: (code) {
                            if (code != null) {
                              ref
                                  .read(boutiFlowServiceProvider)
                                  .updateHotelProfile(
                                    name: user.hotelName,
                                    languageCode: user.languageCode,
                                    currency: code,
                                  );
                              ref
                                  .read(appStateProvider.notifier)
                                  .updateUserProfile(
                                    user.copyWith(currency: code),
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _showLanguagePicker(context, ref, user),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: inputBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: inputBorder),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.language_rounded,
                                    color: textSecondary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.t('language'),
                                        style: GoogleFonts.inter(
                                            color: textSecondary, fontSize: 12),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        AppLocalizations.languageLabel(
                                            user.languageCode),
                                        style: GoogleFonts.inter(
                                            color: textPrimary,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.expand_more_rounded,
                                    color: textSecondary),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: NeoBrutalistTheme.cream,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: inputBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.t('supportedLanguages'),
                                style: GoogleFonts.inter(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                supportedLanguageNames,
                                style: GoogleFonts.inter(color: textMuted),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.edit_note_rounded,
                              color: textSecondary),
                          title: Text(l10n.t('editHotelInfo'),
                              style: GoogleFonts.inter(color: textPrimary)),
                          subtitle: Text(l10n.t('editHotelInfoSubtitle'),
                              style: GoogleFonts.inter(color: textMuted)),
                          trailing: Icon(Icons.chevron_right_rounded,
                              color: textMuted),
                          onTap: () => context.push('/settings/hotel-info'),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.category_rounded,
                              color: textSecondary),
                          title: Text(l10n.t('roomTypes'),
                              style: GoogleFonts.inter(color: textPrimary)),
                          subtitle: Text(l10n.t('roomTypesSubtitle'),
                              style: GoogleFonts.inter(color: textMuted)),
                          trailing: Icon(Icons.chevron_right_rounded,
                              color: textMuted),
                          onTap: () => context.push('/settings/room-types'),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              Icon(Icons.source_rounded, color: textSecondary),
                          title: Text(l10n.t('bookingSources'),
                              style: GoogleFonts.inter(color: textPrimary)),
                          subtitle: Text(l10n.t('activeSources'),
                              style: GoogleFonts.inter(color: textMuted)),
                          trailing: Icon(Icons.chevron_right_rounded,
                              color: textMuted),
                          onTap: () =>
                              context.push('/settings/booking-channels'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Room Management Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionHeader(title: l10n.t('roomManagement')),
                      IconButton(
                        icon: Icon(Icons.add_circle_rounded, color: primary),
                        onPressed: () {
                          final userPlan = user.plan;
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

                          _showRoomDialog(context, ref, null);
                        },
                        tooltip: l10n.t('addRoom'),
                      ),
                    ],
                  ),
                  roomsAsync.when(
                    data: (rooms) => NeoCard(
                      color: NeoBrutalistTheme.white,
                      padding: EdgeInsets.zero,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rooms.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: borderColor),
                        itemBuilder: (context, index) {
                          final room = rooms[index];
                          return ListTile(
                            title: Text(room.name,
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary)),
                            subtitle: Text(
                                '${l10n.t('capacity')}: ${room.capacity}',
                                style: GoogleFonts.inter(color: textSecondary)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.edit_rounded, color: primary),
                                  onPressed: () =>
                                      _showRoomDialog(context, ref, room),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _confirmDeleteRoom(context, ref, room),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    loading: () => Center(
                        child: CircularProgressIndicator(color: primary)),
                    error: (e, s) => Text(
                      l10n.tf('errorWithMessage', {'error': e}),
                      style: TextStyle(color: textPrimary),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Preferences Section
                  _SettingsSection(
                    title: l10n.t('preferences'),
                    children: [
                      ListTile(
                        leading: Icon(Icons.brightness_6_rounded,
                            color: textSecondary),
                        title: Text(l10n.t('theme'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(_getThemeLabel(appState.themeMode, l10n),
                            style: GoogleFonts.inter(color: textMuted)),
                        trailing:
                            Icon(Icons.chevron_right_rounded, color: textMuted),
                        onTap: () =>
                            _showThemeDialog(context, ref, appState.themeMode),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.language_rounded, color: textSecondary),
                        title: Text(l10n.t('language'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(
                          '${AppLocalizations.languageLabel(user.languageCode)} • ${l10n.t('languageManagementHint')}',
                          style: GoogleFonts.inter(color: textMuted),
                        ),
                        trailing:
                            Icon(Icons.chevron_right_rounded, color: textMuted),
                        onTap: () => _showLanguagePicker(context, ref, user),
                      ),
                      SwitchListTile(
                        secondary: Icon(Icons.notifications_active_rounded,
                            color: textSecondary),
                        title: Text(l10n.t('backupReminders'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(l10n.t('backupRemindersSubtitle'),
                            style: GoogleFonts.inter(color: textMuted)),
                        value: appState.backupReminders,
                        activeThumbColor: primary,
                        onChanged: (val) => ref
                            .read(appStateProvider.notifier)
                            .toggleBackupReminders(val),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.backup_rounded, color: textSecondary),
                        title: Text(l10n.t('backupData'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(l10n.t('backupDataSubtitle'),
                            style: GoogleFonts.inter(color: textMuted)),
                        onTap: () async {
                          final hotelId = user.hotelId;
                          if (hotelId.isEmpty) return;
                          final backupService = ref.read(backupServiceProvider);
                          await backupService.exportData(hotelId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.t('dataExported'))),
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.file_upload_rounded,
                            color: textSecondary),
                        title: Text(l10n.t('restoreData'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(l10n.t('restoreDataSubtitle'),
                            style: GoogleFonts.inter(color: textMuted)),
                        onTap: () async {
                          final hotelId = user.hotelId;
                          if (hotelId.isEmpty) return;
                          final backupService = ref.read(backupServiceProvider);
                          await backupService.importData(hotelId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.t('dataRestored'))),
                            );
                          }
                        },
                      ),

                      // Cloud Backup (Premium)
                      PremiumGate(
                        child: Consumer(
                          builder: (context, ref, child) {
                            return FutureBuilder<DateTime?>(
                              future: ref
                                  .read(cloudSyncServiceProvider)
                                  .getLastSyncTime(),
                              builder: (context, snapshot) {
                                final lastSync = snapshot.data;
                                final lastSyncLabel = lastSync != null
                                    ? l10n.tf(
                                        'lastSynced',
                                        {
                                          'date': DateFormat(
                                            'yyyy-MM-dd HH:mm',
                                          ).format(lastSync.toLocal()),
                                        },
                                      )
                                    : l10n.t('neverSynced');
                                return ListTile(
                                  leading: const Icon(Icons.cloud_sync_rounded,
                                      color: Colors.blue),
                                  title: Text(l10n.t('cloudBackup'),
                                      style: GoogleFonts.inter(
                                          color: textPrimary)),
                                  subtitle: Text(
                                    lastSyncLabel,
                                    style: GoogleFonts.inter(color: textMuted),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () async {
                                      final hotelId = user.hotelId;
                                      if (hotelId.isEmpty) return;

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(l10n.t('syncing'))),
                                      );

                                      final result = await ref
                                          .read(cloudSyncServiceProvider)
                                          .syncNow(hotelId);

                                      if (context.mounted) {
                                        if (result.success) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l10n.tf(
                                                  'syncCompleted',
                                                  {
                                                    'pushed':
                                                        result.pushedCount,
                                                    'pulled':
                                                        result.pulledCount,
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l10n.tf(
                                                  'syncFailed',
                                                  {'error': result.error},
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        (context as Element).markNeedsBuild();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(l10n.t('syncNow'),
                                        style: GoogleFonts.inter()),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      // Restore Data Button
                      NeoCard(
                        color: NeoBrutalistTheme.white,
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: const Icon(Icons.cloud_download_rounded,
                              color: Colors.green),
                          title: Text(l10n.t('restoreFromCloud'),
                              style: GoogleFonts.inter(color: textPrimary)),
                          subtitle: Text(l10n.t('restoreFromCloudSubtitle'),
                              style: GoogleFonts.inter(color: textMuted)),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final cloudSync =
                                  ref.read(cloudSyncServiceProvider);

                              // First find the hotelId from cloud
                              final hotelId =
                                  await cloudSync.findHotelIdFromCloud();

                              if (hotelId == null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(l10n.t('noCloudData'))),
                                  );
                                }
                                return;
                              }

                              // Restore data
                              final result =
                                  await cloudSync.restoreFromCloud(hotelId);

                              if (context.mounted) {
                                if (result.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.tf(
                                          'restoreSuccess',
                                          {'count': result.restoredCount},
                                        ),
                                      ),
                                    ),
                                  );
                                  // Refresh all providers
                                  ref.invalidate(roomsProvider);
                                  ref.invalidate(guestsProvider);
                                  ref.invalidate(bookingsProvider);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.tf(
                                          'restoreFailed',
                                          {'error': result.error},
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(l10n.t('restoreFromCloud'),
                                style: GoogleFonts.inter()),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Upgrade Section
                  _SectionHeader(title: l10n.t('upgrade')),
                  NeoCard(
                    color: NeoBrutalistTheme.purple,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(Icons.stars_rounded,
                          color: Colors.amber, size: 32),
                      title: Text(l10n.t('upgradeTitle'),
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      subtitle: Text(l10n.t('upgradeSubtitle'),
                          style: GoogleFonts.inter(color: Colors.white70)),
                      trailing: FilledButton(
                        onPressed: () => ref
                            .read(appStateProvider.notifier)
                            .upgradePlan(PlanType.premium),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: const Color(0xFF1A202C),
                        ),
                        child: Text(l10n.t('upgrade'),
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Legal & Support Section
                  _SettingsSection(
                    title: l10n.t('legalSupport'),
                    children: [
                      ListTile(
                        leading: Icon(Icons.privacy_tip_rounded,
                            color: textSecondary),
                        title: Text(l10n.t('privacyPolicy'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(l10n.t('privacyPolicySub'),
                            style: GoogleFonts.inter(color: textMuted)),
                        trailing:
                            Icon(Icons.open_in_new_rounded, color: textMuted),
                        onTap: () => _openWebPage(context, 'privacy.html'),
                      ),
                      ListTile(
                        leading: Icon(Icons.description_rounded,
                            color: textSecondary),
                        title: Text(l10n.t('termsOfService'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(l10n.t('termsOfServiceSub'),
                            style: GoogleFonts.inter(color: textMuted)),
                        trailing:
                            Icon(Icons.open_in_new_rounded, color: textMuted),
                        onTap: () => _openWebPage(context, 'terms.html'),
                      ),
                      ListTile(
                        leading: Icon(Icons.help_outline_rounded,
                            color: textSecondary),
                        title: Text(l10n.t('helpSupport'),
                            style: GoogleFonts.inter(color: textPrimary)),
                        subtitle: Text(l10n.t('helpSupportSub'),
                            style: GoogleFonts.inter(color: textMuted)),
                        trailing:
                            Icon(Icons.open_in_new_rounded, color: textMuted),
                        onTap: () => _openWebPage(context, 'support.html'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_forever_rounded,
                            color: Colors.redAccent),
                        title: Text(l10n.t('accountDeletionRequest'),
                            style: GoogleFonts.inter(color: Colors.redAccent)),
                        subtitle: Text(l10n.t('accountDeletionRequestSub'),
                            style: GoogleFonts.inter(color: textMuted)),
                        trailing: const Icon(Icons.chevron_right_rounded,
                            color: Colors.redAccent),
                        onTap: () =>
                            _confirmAccountDeletionRequest(context, user),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(appStateProvider.notifier).signOut();
                    },
                    icon: const Icon(Icons.logout_rounded,
                        color: Colors.redAccent),
                    label: Text(l10n.t('logout'),
                        style: GoogleFonts.inter(color: Colors.redAccent)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openWebPage(BuildContext context, String page) async {
    final url = buildLegalPageUri(page, context.l10n.locale.languageCode);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _confirmAccountDeletionRequest(
    BuildContext context,
    UserProfile user,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: NeoBrutalistTheme.cream,
            title: Text(
              l10n.t('accountDeletionDialogTitle'),
              style: NeoBrutalistTheme.titleLarge,
            ),
            content: Text(
              l10n.t('accountDeletionDialogBody'),
              style: NeoBrutalistTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.t('cancel')),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: NeoBrutalistTheme.white,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.t('sendRequest')),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed || !context.mounted) return;

    final uri = buildAccountDeletionRequestUri(user);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.t('accountDeletionMailError'))),
    );
    _openWebPage(context, 'support.html');
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, UserProfile user) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final sheetHeight = MediaQuery.of(sheetContext).size.height * 0.72;
        return SafeArea(
          top: false,
          child: Container(
            height: sheetHeight,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: NeoBrutalistTheme.cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                top: BorderSide(color: NeoBrutalistTheme.black, width: 3),
                left: BorderSide(color: NeoBrutalistTheme.black, width: 3),
                right: BorderSide(color: NeoBrutalistTheme.black, width: 3),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.grey,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.upper('language'),
                    style: NeoBrutalistTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.t('supportedLanguagesSubtitle'),
                    style: NeoBrutalistTheme.bodyMedium.copyWith(
                      color: NeoBrutalistTheme.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: supportedLanguageCodes.length,
                      itemBuilder: (context, index) {
                        final code = supportedLanguageCodes[index];
                        final isSelected = code == user.languageCode;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pop(sheetContext);
                              await _applyLanguage(context, ref, user, code);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? NeoBrutalistTheme.blue
                                    : NeoBrutalistTheme.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: NeoBrutalistTheme.black,
                                  width: 2,
                                ),
                                boxShadow: isSelected
                                    ? NeoBrutalistTheme.brutalistShadowSmall
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    AppLocalizations.languageLabel(code),
                                    style:
                                        NeoBrutalistTheme.titleMedium.copyWith(
                                      color: isSelected
                                          ? NeoBrutalistTheme.white
                                          : NeoBrutalistTheme.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: NeoBrutalistTheme.white,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _applyLanguage(
    BuildContext context,
    WidgetRef ref,
    UserProfile user,
    String code,
  ) async {
    await ref.read(appStateProvider.notifier).changeLanguage(code);
    await ref.read(boutiFlowServiceProvider).updateHotelProfile(
          name: user.hotelName,
          languageCode: code,
          currency: user.currency,
        );
  }

  void _showRoomDialog(BuildContext context, WidgetRef ref, Room? room) {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: room?.name ?? '');
    final capacityController =
        TextEditingController(text: room?.capacity.toString() ?? '2');
    String? selectedTypeId = room?.type?.id;

    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final roomTypesAsync = ref.watch(roomTypesProvider);

          return AlertDialog(
            backgroundColor: NeoBrutalistTheme.cream,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
            ),
            title: Text(
              room == null
                  ? l10n.upper('roomAddTitle')
                  : l10n.upper('roomEditTitle'),
              style: NeoBrutalistTheme.titleLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: l10n.t('roomName'),
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
                roomTypesAsync.when(
                  data: (types) {
                    if (selectedTypeId == null && types.isNotEmpty) {
                      final std =
                          types.where((t) => t.name == 'Standard').firstOrNull;
                      selectedTypeId = std?.id ?? types.first.id;
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: selectedTypeId,
                      dropdownColor: NeoBrutalistTheme.white,
                      style: NeoBrutalistTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: l10n.t('roomType'),
                        labelStyle: NeoBrutalistTheme.bodyMedium,
                        filled: true,
                        fillColor: NeoBrutalistTheme.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: NeoBrutalistTheme.black, width: 2),
                        ),
                      ),
                      items: types.isEmpty
                          ? [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text(l10n.t('noRoomTypesYet'),
                                    style: NeoBrutalistTheme.bodyMedium
                                        .copyWith(
                                            color: NeoBrutalistTheme.grey)),
                              )
                            ]
                          : types
                              .map<DropdownMenuItem<String>>(
                                  (t) => DropdownMenuItem(
                                        value: t.id,
                                        child: Text(t.name),
                                      ))
                              .toList(),
                      onChanged: types.isEmpty
                          ? null
                          : (val) {
                              selectedTypeId = val;
                            },
                    );
                  },
                  loading: () => const LinearProgressIndicator(
                      color: NeoBrutalistTheme.blue),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  style: NeoBrutalistTheme.bodyLarge,
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
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.upper('cancel'),
                  style: NeoBrutalistTheme.labelLarge.copyWith(
                    color: NeoBrutalistTheme.grey,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final name = nameController.text;
                  final capacity = int.tryParse(capacityController.text) ?? 2;

                  if (name.isNotEmpty) {
                    if (room == null) {
                      final hotelId =
                          ref.read(appStateProvider).user?.hotelId ?? '';
                      await ref.read(boutiFlowServiceProvider).createRoom(
                            name,
                            hotelId: hotelId,
                            capacity: capacity,
                            roomTypeId: selectedTypeId,
                          );
                    } else {
                      await ref
                          .read(boutiFlowServiceProvider)
                          .updateRoom(room.copyWith(
                            name: name,
                            capacity: capacity,
                            type: selectedTypeId != null
                                ? RoomType(
                                    id: selectedTypeId!, name: '', price: 0)
                                : null,
                          ));
                    }
                    ref.invalidate(roomsProvider);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration:
                      NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
                  child: Text(
                    l10n.upper('save'),
                    style: NeoBrutalistTheme.labelLarge.copyWith(
                      color: NeoBrutalistTheme.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteRoom(BuildContext context, WidgetRef ref, Room room) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoBrutalistTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
        ),
        title: Text(l10n.upper('deleteRoomTitle'),
            style: NeoBrutalistTheme.titleLarge),
        content: Text(
          l10n.t('deleteRoomConfirmation'),
          style: NeoBrutalistTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.upper('cancel'),
              style: NeoBrutalistTheme.labelLarge.copyWith(
                color: NeoBrutalistTheme.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await ref.read(boutiFlowServiceProvider).deleteRoom(room.id);
              ref.invalidate(roomsProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.red),
              child: Text(
                l10n.upper('delete'),
                style: NeoBrutalistTheme.labelLarge.copyWith(
                  color: NeoBrutalistTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.t('systemDefault');
      case ThemeMode.light:
        return l10n.t('lightMode');
      case ThemeMode.dark:
        return l10n.t('darkMode');
    }
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: const Color(0xFF2D3748),
        title: Text(l10n.t('selectTheme'),
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.white)),
        children: [
          SimpleDialogOption(
            onPressed: () {
              ref
                  .read(appStateProvider.notifier)
                  .setThemeMode(ThemeMode.system);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.brightness_auto,
                    color: currentMode == ThemeMode.system
                        ? const Color(0xFFFFC107)
                        : Colors.white54),
                const SizedBox(width: 12),
                Text(l10n.t('systemDefault'),
                    style: GoogleFonts.inter(
                        fontWeight: currentMode == ThemeMode.system
                            ? FontWeight.bold
                            : null,
                        color: Colors.white)),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.light);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.light_mode,
                    color: currentMode == ThemeMode.light
                        ? const Color(0xFFFFC107)
                        : Colors.white54),
                const SizedBox(width: 12),
                Text(l10n.t('lightMode'),
                    style: GoogleFonts.inter(
                        fontWeight: currentMode == ThemeMode.light
                            ? FontWeight.bold
                            : null,
                        color: Colors.white)),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.dark);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.dark_mode,
                    color: currentMode == ThemeMode.dark
                        ? const Color(0xFFFFC107)
                        : Colors.white54),
                const SizedBox(width: 12),
                Text(l10n.t('darkMode'),
                    style: GoogleFonts.inter(
                        fontWeight: currentMode == ThemeMode.dark
                            ? FontWeight.bold
                            : null,
                        color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, top: 8.0),
      child: Text(
        l10n.upperText(title),
        style: NeoBrutalistTheme.labelLarge.copyWith(
          color: NeoBrutalistTheme.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title),
        Container(
          decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.white),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
