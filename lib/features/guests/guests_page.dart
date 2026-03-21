import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/services/interstitial_ad_service.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../paywall/paywall_provider.dart';
import 'data/models/guest_model.dart';
import 'presentation/providers/guest_providers.dart';

class GuestsPage extends ConsumerStatefulWidget {
  const GuestsPage({super.key});

  @override
  ConsumerState<GuestsPage> createState() => _GuestsPageState();
}

class _GuestsPageState extends ConsumerState<GuestsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  String _flagForLanguage(String code) {
    switch (code) {
      case 'tr':
        return '🇹🇷';
      case 'de':
        return '🇩🇪';
      case 'ru':
        return '🇷🇺';
      case 'fr':
        return '🇫🇷';
      case 'es':
        return '🇪🇸';
      default:
        return '🇬🇧';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final guestsAsync = ref.watch(guestListProvider);

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // === HEADER ===
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.t('guests').toUpperCase(),
                    style: NeoBrutalistTheme.headlineLarge,
                  ),
                  GestureDetector(
                    onTap: () => _showAddGuestDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: NeoBrutalistTheme.cardDecoration(
                          NeoBrutalistTheme.purple),
                      child: const Icon(
                        Icons.person_add_rounded,
                        color: NeoBrutalistTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // === SEARCH BAR ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: NeoBrutalistTheme.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoBrutalistTheme.black, width: 2),
                ),
                child: TextField(
                  controller: _searchController,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: l10n.t('searchGuests'),
                    hintStyle: NeoBrutalistTheme.bodyMedium
                        .copyWith(color: NeoBrutalistTheme.grey),
                    prefixIcon:
                        const Icon(Icons.search, color: NeoBrutalistTheme.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: NeoBrutalistTheme.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value.toLowerCase()),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // === GUESTS LIST ===
            Expanded(
              child: guestsAsync.when(
                data: (guests) {
                  // Filter guests by search query
                  final filteredGuests = _searchQuery.isEmpty
                      ? guests
                      : guests
                          .where((g) =>
                              g.fullName.toLowerCase().contains(_searchQuery) ||
                              (g.phone?.toLowerCase().contains(_searchQuery) ??
                                  false) ||
                              (g.email?.toLowerCase().contains(_searchQuery) ??
                                  false))
                          .toList();

                  if (filteredGuests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: NeoBrutalistTheme.cardDecoration(
                                NeoBrutalistTheme.purple
                                    .withValues(alpha: 0.2)),
                            child: const Icon(
                              Icons.people_outline_rounded,
                              size: 64,
                              color: NeoBrutalistTheme.purple,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _searchQuery.isEmpty
                                ? l10n.t('noGuestsYet')
                                : l10n.t('noSearchResults'),
                            style: NeoBrutalistTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isEmpty
                                ? l10n.t('addFirstGuest')
                                : l10n.t('tryDifferentSearch'),
                            style: NeoBrutalistTheme.bodyLarge.copyWith(
                              color: NeoBrutalistTheme.grey,
                            ),
                          ),
                          if (_searchQuery.isEmpty) ...[
                            const SizedBox(height: 24),
                            NeoButton(
                              text: '+ ${l10n.t('addGuest')}',
                              onPressed: () => _showAddGuestDialog(context),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    itemCount: filteredGuests.length,
                    itemBuilder: (context, index) {
                      final guest = filteredGuests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: Key(guest.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: NeoBrutalistTheme.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete_rounded,
                                color: NeoBrutalistTheme.white, size: 28),
                          ),
                          confirmDismiss: (direction) =>
                              _confirmDelete(context, guest),
                          onDismissed: (direction) {
                            ref
                                .read(guestControllerProvider.notifier)
                                .deleteGuest(guest.id);
                          },
                          child: _GuestCard(
                            guest: guest,
                            l10n: l10n,
                            onTap: () => _showEditGuestDialog(context, guest),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: NeoBrutalistTheme.black,
                        strokeWidth: 4,
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.t('loading'),
                          style: NeoBrutalistTheme.titleMedium),
                    ],
                  ),
                ),
                error: (e, _) => Center(
                  child: NeoCard(
                    color: NeoBrutalistTheme.red,
                    child: Text(
                      l10n.tf('errorWithMessage', {'error': e}),
                      style: NeoBrutalistTheme.bodyLargeWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, GuestModel guest) async {
    final l10n = context.l10n;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: NeoBrutalistTheme.cream,
            title: Text(l10n.t('deleteGuestTitle'),
                style: NeoBrutalistTheme.titleLarge),
            content: Text(
                l10n.tf('deleteGuestConfirmation', {'name': guest.fullName})),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.t('cancel')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoBrutalistTheme.red,
                  foregroundColor: NeoBrutalistTheme.white,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.upper('delete')),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showAddGuestDialog(BuildContext context) {
    final l10n = context.l10n;
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final nationalIdController = TextEditingController();
    String selectedLanguage = 'tr';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: NeoBrutalistTheme.cream,
          title: Row(
            children: [
              Text(l10n.t('addGuest'), style: NeoBrutalistTheme.titleLarge),
              const Spacer(),
              // OCR Camera Button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.t('ocrComingSoon'))),
                  );
                  debugPrint('TODO: OCR scanning');
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NeoBrutalistTheme.orange,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: NeoBrutalistTheme.black, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: NeoBrutalistTheme.white, size: 20),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name field with OCR icon
                TextField(
                  controller: nameController,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: '${l10n.t('name')} *',
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: NeoBrutalistTheme.black, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  style: NeoBrutalistTheme.bodyLarge,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.t('phone'),
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: NeoBrutalistTheme.black, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nationalIdController,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: l10n.t('nationalIdPassport'),
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    prefixIcon: const Icon(Icons.badge_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: NeoBrutalistTheme.black, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Language dropdown
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: l10n.t('language'),
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    prefixIcon: const Icon(Icons.language),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: NeoBrutalistTheme.black, width: 2),
                    ),
                  ),
                  items: supportedLanguageCodes.map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text(
                          '${_flagForLanguage(code)} ${AppLocalizations.languageLabel(code)}'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedLanguage = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.t('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoBrutalistTheme.green,
                foregroundColor: NeoBrutalistTheme.white,
              ),
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.t('nameRequired'))),
                  );
                  return;
                }

                await ref.read(guestControllerProvider.notifier).addGuest(
                      fullName: name,
                      phone: phoneController.text.trim().isEmpty
                          ? null
                          : phoneController.text.trim(),
                      nationalId: nationalIdController.text.trim().isEmpty
                          ? null
                          : nationalIdController.text.trim(),
                      languageCode: selectedLanguage,
                    );

                // Show interstitial ad for free users
                if (!ref.read(isProProvider)) {
                  InterstitialAdService.instance.showAd();
                }

                if (context.mounted) Navigator.pop(ctx);
              },
              child: Text(l10n.upper('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGuestDialog(BuildContext context, GuestModel guest) {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: guest.fullName);
    final phoneController = TextEditingController(text: guest.phone ?? '');
    final nationalIdController =
        TextEditingController(text: guest.nationalId ?? '');
    String selectedLanguage = guest.languageCode;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: NeoBrutalistTheme.cream,
          title: Text(l10n.t('editGuest'), style: NeoBrutalistTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: '${l10n.t('name')} *',
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  style: NeoBrutalistTheme.bodyLarge,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.t('phone'),
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nationalIdController,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: l10n.t('nationalIdPassport'),
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    prefixIcon: const Icon(Icons.badge_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  style: NeoBrutalistTheme.bodyLarge,
                  decoration: InputDecoration(
                    labelText: l10n.t('language'),
                    labelStyle: NeoBrutalistTheme.bodyMedium,
                    filled: true,
                    fillColor: NeoBrutalistTheme.white,
                    prefixIcon: const Icon(Icons.language),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: supportedLanguageCodes.map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text(
                          '${_flagForLanguage(code)} ${AppLocalizations.languageLabel(code)}'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedLanguage = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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

                final updatedGuest = guest.copyWith(
                  fullName: name,
                  phone: phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                  nationalId: nationalIdController.text.trim().isEmpty
                      ? null
                      : nationalIdController.text.trim(),
                  languageCode: selectedLanguage,
                );

                await ref
                    .read(guestControllerProvider.notifier)
                    .updateGuest(updatedGuest);

                if (context.mounted) Navigator.pop(ctx);
              },
              child: Text(l10n.upper('update')),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestCard extends StatelessWidget {
  final GuestModel guest;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _GuestCard({
    required this.guest,
    required this.l10n,
    required this.onTap,
  });

  // Get flag emoji from language code
  String _getFlagEmoji(String langCode) {
    switch (langCode) {
      case 'tr':
        return '🇹🇷';
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      case 'ru':
        return '🇷🇺';
      case 'fr':
        return '🇫🇷';
      case 'es':
        return '🇪🇸';
      default:
        return '🌍';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Assign color based on guest name hash
    final colors = [
      NeoBrutalistTheme.blue,
      NeoBrutalistTheme.red,
      NeoBrutalistTheme.green,
      NeoBrutalistTheme.purple,
      NeoBrutalistTheme.orange,
    ];
    final cardColor = colors[guest.fullName.hashCode.abs() % colors.length];

    return GestureDetector(
      onTap: onTap,
      child: NeoCard(
        color: NeoBrutalistTheme.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar with flag
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: NeoBrutalistTheme.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      guest.fullName.isNotEmpty
                          ? guest.fullName[0].toUpperCase()
                          : '?',
                      style: NeoBrutalistTheme.headlineMedium.copyWith(
                        color: NeoBrutalistTheme.white,
                      ),
                    ),
                  ),
                ),
                // Flag badge
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: NeoBrutalistTheme.white,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: NeoBrutalistTheme.black, width: 1),
                    ),
                    child: Text(_getFlagEmoji(guest.languageCode),
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          guest.fullName,
                          style: NeoBrutalistTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (guest.isBlacklisted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: NeoBrutalistTheme.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child:
                              const Text('⚠️', style: TextStyle(fontSize: 10)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (guest.phone != null && guest.phone!.isNotEmpty)
                    Text(
                      guest.phone!,
                      style: NeoBrutalistTheme.bodyMedium.copyWith(
                        color: NeoBrutalistTheme.grey,
                      ),
                    ),
                  if (guest.nationality.isNotEmpty)
                    Text(
                      guest.nationality,
                      style: NeoBrutalistTheme.bodyMedium.copyWith(
                        color: NeoBrutalistTheme.grey,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            // WhatsApp button
            if (guest.phone != null && guest.phone!.isNotEmpty)
              GestureDetector(
                onTap: () => _openWhatsApp(guest.phone!),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: NeoBrutalistTheme.green,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: NeoBrutalistTheme.black, width: 2),
                  ),
                  child: const Icon(
                    Icons.chat_rounded,
                    color: NeoBrutalistTheme.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final url = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
