import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../state/app_state.dart';
import '../../services/providers.dart';
import '../../core/services/plan_limits.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class OnboardingWizard extends ConsumerStatefulWidget {
  const OnboardingWizard({super.key});

  @override
  ConsumerState<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends ConsumerState<OnboardingWizard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State variables
  String _selectedLanguage = 'en';
  final _hotelNameController = TextEditingController();
  String _selectedCurrency = 'EUR';
  String _checkInHour = '14:00';
  String _checkOutHour = '11:00';
  double _defaultRoomPrice = 100.0;
  int _roomCount = 1; // Free tier: max 1 room
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with current system locale if supported
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final systemLoc = View.of(context).platformDispatcher.locale.languageCode;
      if (['en', 'tr', 'de', 'ru', 'fr', 'es'].contains(systemLoc)) {
        setState(() => _selectedLanguage = systemLoc);
      }
    });
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    final l10n = context.l10n;
    try {
      // Get language from appState (already selected in intro)
      final appState = ref.read(appStateProvider);
      final languageCode = appState.selectedLocale ?? 'en';

      // Create hotel and user in local DB
      final service = ref.read(boutiFlowServiceProvider);

      // Register user with hotel info (skip if already exists)
      try {
        await ref.read(appStateProvider.notifier).register(
              email:
                  'user@hotel.app', // Placeholder - Supabase auth handles real email
              password: 'socialauth', // Placeholder
              hotelName: _hotelNameController.text.trim(),
              languageCode: languageCode,
            );
      } catch (registerErr) {
        debugPrint('User already exists, continuing: $registerErr');
        // Log in with existing user instead
        await ref.read(appStateProvider.notifier).signIn(
              email: 'user@hotel.app',
              password: 'socialauth',
            );
      }

      // Update hotel profile with settings
      final user = ref.read(appStateProvider).user;
      if (user != null) {
        await service.updateHotelProfile(
          name: user.hotelName,
          languageCode: user.languageCode,
          currency: _selectedCurrency,
          checkInHour: _checkInHour,
          checkOutHour: _checkOutHour,
          defaultRoomPrice: _defaultRoomPrice,
        );

        // Create initial rooms
        for (int i = 1; i <= _roomCount; i++) {
          await service.createRoom(
            '${l10n.t('room')} $i',
            hotelId: user.hotelId,
            capacity: 2,
          );
        }

        // Sync to Supabase
        try {
          final cloudSync = ref.read(cloudSyncServiceProvider);
          final result = await cloudSync.syncNow(user.hotelId);
          if (mounted) {
            if (result.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.tf('cloudSyncSuccess', {'count': result.pushedCount}),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.tf('cloudSyncError', {'error': result.error}),
                  ),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        } catch (syncError) {
          debugPrint('Cloud sync error: $syncError');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.tf('cloudSyncException', {'error': syncError}),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      }

      // Short delay to show snackbar
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use a specific localization for the wizard based on selection
    // But for simplicity, we'll use the app's current context l10n for labels
    // In a real app, we might want to force rebuild l10n based on _selectedLanguage
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(2, (index) {
                  return Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.only(right: index < 1 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? NeoBrutalistTheme.blue
                            : NeoBrutalistTheme.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildHotelStep(l10n),
                  _buildRoomStep(l10n),
                ],
              ),
            ),
            _buildBottomBar(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageStep(AppLocalizations l10n) {
    final languages = {
      'en': (
        AppLocalizations.languageLabel('en'),
        '🇬🇧',
        NeoBrutalistTheme.blue
      ),
      'tr': (
        AppLocalizations.languageLabel('tr'),
        '🇹🇷',
        NeoBrutalistTheme.red
      ),
      'de': (
        AppLocalizations.languageLabel('de'),
        '🇩🇪',
        NeoBrutalistTheme.yellow
      ),
      'ru': (
        AppLocalizations.languageLabel('ru'),
        '🇷🇺',
        NeoBrutalistTheme.purple
      ),
      'fr': (
        AppLocalizations.languageLabel('fr'),
        '🇫🇷',
        NeoBrutalistTheme.green
      ),
      'es': (
        AppLocalizations.languageLabel('es'),
        '🇪🇸',
        NeoBrutalistTheme.orange
      ),
    };

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration:
                NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.blue),
            child: const Icon(Icons.language_rounded,
                size: 40, color: NeoBrutalistTheme.white),
          ),
          const SizedBox(height: 24),
          Text(l10n.upper('chooseLanguageTitle'),
              style: NeoBrutalistTheme.headlineLarge),
          const SizedBox(height: 32),
          ...languages.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() => _selectedLanguage = e.key);
                    ref.read(appStateProvider.notifier).setLanguage(e.key);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedLanguage == e.key
                          ? e.value.$3
                          : NeoBrutalistTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: NeoBrutalistTheme.black, width: 3),
                      boxShadow: _selectedLanguage == e.key
                          ? NeoBrutalistTheme.brutalistShadowSmall
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(e.value.$2, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 16),
                        Text(
                          e.value.$1,
                          style: NeoBrutalistTheme.titleMedium.copyWith(
                            color: _selectedLanguage == e.key
                                ? NeoBrutalistTheme.white
                                : NeoBrutalistTheme.black,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedLanguage == e.key)
                          const Icon(Icons.check_circle,
                              color: NeoBrutalistTheme.white),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildHotelStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.orange),
              child: const Icon(Icons.hotel_rounded,
                  size: 40, color: NeoBrutalistTheme.white),
            ),
            const SizedBox(height: 24),
            Text(l10n.upper('onboardingHotelInfoTitle'),
                style: NeoBrutalistTheme.headlineLarge),
            const SizedBox(height: 32),
            NeoCard(
              color: NeoBrutalistTheme.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _hotelNameController,
                    style: NeoBrutalistTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: l10n.t('hotelName'),
                      labelStyle: NeoBrutalistTheme.bodyMedium,
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
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    style: NeoBrutalistTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: l10n.t('currency'),
                      labelStyle: NeoBrutalistTheme.bodyMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                    ),
                    items: ['EUR', 'USD', 'TRY', 'GBP', 'RUB'].map((code) {
                      return DropdownMenuItem(value: code, child: Text(code));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCurrency = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _checkInHour,
                          style: NeoBrutalistTheme.bodyLarge,
                          decoration: InputDecoration(
                            labelText: l10n.t('checkInLabel'),
                            labelStyle: NeoBrutalistTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: NeoBrutalistTheme.black, width: 2),
                            ),
                          ),
                          onChanged: (val) =>
                              setState(() => _checkInHour = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _checkOutHour,
                          style: NeoBrutalistTheme.bodyLarge,
                          decoration: InputDecoration(
                            labelText: l10n.t('checkOutLabel'),
                            labelStyle: NeoBrutalistTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: NeoBrutalistTheme.black, width: 2),
                            ),
                          ),
                          onChanged: (val) =>
                              setState(() => _checkOutHour = val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration:
                NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.purple),
            child: const Icon(Icons.bed_rounded,
                size: 40, color: NeoBrutalistTheme.white),
          ),
          const SizedBox(height: 24),
          Text(l10n.upper('onboardingRoomSettingsTitle'),
              style: NeoBrutalistTheme.headlineLarge),
          const SizedBox(height: 16),
          Text(
            l10n.t('onboardingFreeRoomLimit'),
            style: NeoBrutalistTheme.bodyLarge
                .copyWith(color: NeoBrutalistTheme.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          NeoCard(
            color: NeoBrutalistTheme.purple,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  '${PlanLimits.freeMaxRooms}',
                  style: NeoBrutalistTheme.displayLarge
                      .copyWith(color: NeoBrutalistTheme.white),
                ),
                Text(
                  l10n.upper('onboardingFreeRoom'),
                  style: NeoBrutalistTheme.labelLarge
                      .copyWith(color: NeoBrutalistTheme.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push('/paywall'),
            child: NeoCard(
              color: NeoBrutalistTheme.yellow,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: NeoBrutalistTheme.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.t('onboardingPremiumUnlimitedRooms'),
                      style: NeoBrutalistTheme.bodyMedium,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: NeoBrutalistTheme.black, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
              child: const Icon(Icons.person_rounded,
                  size: 40, color: NeoBrutalistTheme.white),
            ),
            const SizedBox(height: 24),
            Text(l10n.upper('createAccount'),
                style: NeoBrutalistTheme.headlineLarge),
            const SizedBox(height: 32),
            NeoCard(
              color: NeoBrutalistTheme.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    style: NeoBrutalistTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: l10n.t('email'),
                      labelStyle: NeoBrutalistTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.email_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                    ),
                    validator: (v) => v != null && v.contains('@')
                        ? null
                        : l10n.t('invalidEmail'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: NeoBrutalistTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: l10n.t('password'),
                      labelStyle: NeoBrutalistTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                    ),
                    validator: (v) => v != null && v.length >= 6
                        ? null
                        : l10n.t('minPasswordLength'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            GestureDetector(
              onTap: _previousPage,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: NeoBrutalistTheme.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: NeoBrutalistTheme.black, width: 2),
                ),
                child: Text(l10n.upper('onboardingBack'),
                    style: NeoBrutalistTheme.labelLarge),
              ),
            )
          else
            const SizedBox.shrink(),
          GestureDetector(
            onTap: _currentPage == 1 ? _finishOnboarding : _nextPage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: NeoBrutalistTheme.cardDecoration(
                _currentPage == 1
                    ? NeoBrutalistTheme.green
                    : NeoBrutalistTheme.blue,
              ),
              child: Text(
                _currentPage == 1
                    ? l10n.upper('onboardingComplete')
                    : l10n.upper('onboardingNext'),
                style: NeoBrutalistTheme.labelLarge
                    .copyWith(color: NeoBrutalistTheme.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
