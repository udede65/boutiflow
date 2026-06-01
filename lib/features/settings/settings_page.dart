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
import '../../services/notification_preferences.dart';
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
    final borderColor = NeoBrutalistTheme.black.withValues(alpha: 0.1);
    const primary = NeoBrutalistTheme.blue;

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
                  _BusinessProfileCard(
                    user: user,
                    l10n: l10n,
                    onEditProfile: () => context.push('/settings/hotel-info'),
                    onLanguage: () => _showLanguagePicker(context, ref, user),
                    onRoomTypes: () => context.push('/settings/room-types'),
                    onSources: () => context.push('/settings/booking-channels'),
                  ),

                  const SizedBox(height: 20),
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

                  const SizedBox(height: 24),

                  // Preferences Section
                  _SettingsSection(
                    title: l10n.t('preferences'),
                    children: [
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
                        onChanged: (val) async {
                          ref
                              .read(appStateProvider.notifier)
                              .toggleBackupReminders(val);
                          await NotificationPreferences
                              .setBackupRemindersEnabled(val);
                        },
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
                          await NotificationPreferences.markBackupCompleted();
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
                                      if (result.success) {
                                        await NotificationPreferences
                                            .markBackupCompleted();
                                      }

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

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 24),

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

                  const SizedBox(height: 24),
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
    ref.read(appStateProvider.notifier).changeLanguage(code);
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
}

class _BusinessProfileCard extends StatelessWidget {
  const _BusinessProfileCard({
    required this.user,
    required this.l10n,
    required this.onEditProfile,
    required this.onLanguage,
    required this.onRoomTypes,
    required this.onSources,
  });

  final UserProfile user;
  final AppLocalizations l10n;
  final VoidCallback onEditProfile;
  final VoidCallback onLanguage;
  final VoidCallback onRoomTypes;
  final VoidCallback onSources;

  @override
  Widget build(BuildContext context) {
    final isPremium = PlanLimits.isPremium(user.plan);

    return NeoCard(
      color: NeoBrutalistTheme.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: NeoBrutalistTheme.black,
                    width: 3,
                  ),
                  boxShadow: NeoBrutalistTheme.brutalistShadowSmall,
                ),
                child: Image.asset(
                  'assets/app_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.upper('hotelProfile'),
                      style: NeoBrutalistTheme.labelLarge.copyWith(
                        color: NeoBrutalistTheme.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.hotelName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: NeoBrutalistTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ProfilePill(
                          icon: Icons.workspace_premium_rounded,
                          label: isPremium
                              ? l10n.t('premium')
                              : l10n.t('freePlan'),
                          color: isPremium
                              ? NeoBrutalistTheme.yellow
                              : NeoBrutalistTheme.cream,
                        ),
                        _ProfilePill(
                          icon: Icons.payments_rounded,
                          label:
                              '${user.currency} ${getCurrencySymbol(user.currency)}',
                          color: NeoBrutalistTheme.cream,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onEditProfile,
                icon: const Icon(Icons.edit_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: NeoBrutalistTheme.blue,
                  foregroundColor: NeoBrutalistTheme.white,
                  side: const BorderSide(
                    color: NeoBrutalistTheme.black,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ProfileAction(
                  icon: Icons.language_rounded,
                  label: AppLocalizations.languageLabel(user.languageCode),
                  onTap: onLanguage,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileAction(
                  icon: Icons.category_rounded,
                  label: l10n.t('roomTypes'),
                  onTap: onRoomTypes,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ProfileAction(
            icon: Icons.source_rounded,
            label: l10n.t('bookingSources'),
            onTap: onSources,
            wide: true,
          ),
        ],
      ),
    );
  }
}

class _ProfilePill extends StatelessWidget {
  const _ProfilePill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: NeoBrutalistTheme.black, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: NeoBrutalistTheme.black),
          const SizedBox(width: 5),
          Text(label, style: NeoBrutalistTheme.labelLarge),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.wide = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NeoBrutalistTheme.cream,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: wide ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: NeoBrutalistTheme.black, width: 2),
          ),
          child: Row(
            mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: NeoBrutalistTheme.black),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NeoBrutalistTheme.labelLarge,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
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
