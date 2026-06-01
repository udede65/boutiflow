import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/revenuecat_service.dart';
import '../../state/app_state.dart';
import '../../services/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // === LOGO ===
              Container(
                width: 120,
                height: 120,
                decoration:
                    NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.yellow),
                child: const Icon(
                  Icons.hotel_rounded,
                  size: 60,
                  color: NeoBrutalistTheme.black,
                ),
              ),
              const SizedBox(height: 24),

              // === TITLE ===
              Text(
                'BOUTIFLOW',
                style: NeoBrutalistTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.t('appTagline'),
                style: NeoBrutalistTheme.bodyLarge.copyWith(
                  color: NeoBrutalistTheme.grey,
                ),
              ),
              const SizedBox(height: 60),

              // === ERROR MESSAGE ===
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NeoBrutalistTheme.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: NeoBrutalistTheme.red, width: 2),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: NeoBrutalistTheme.bodyMedium
                        .copyWith(color: NeoBrutalistTheme.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // === APPLE LOGIN ===
              NeoCard(
                color: NeoBrutalistTheme.white,
                child: Column(
                  children: [
                    _SocialLoginButton(
                      icon: Icons.apple_rounded,
                      label: l10n.t('loginWithApple'),
                      color: NeoBrutalistTheme.black,
                      isLoading: _isLoading,
                      onTap: _signInWithApple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // === INFO TEXT ===
              Text(
                l10n.t('termsAcceptance'),
                style: NeoBrutalistTheme.bodyMedium.copyWith(
                  color: NeoBrutalistTheme.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithApple() async {
    final l10n = context.l10n;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result =
          await ref.read(supabaseAuthServiceProvider).signInWithApple();

      if (result.success) {
        await _handleSuccessfulLogin(result.email);
      } else {
        setState(() =>
            _errorMessage = result.error ?? l10n.t('signInFailedOrCancelled'));
      }
    } catch (e) {
      setState(() => _errorMessage = l10n.tf('errorWithMessage', {'error': e}));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSuccessfulLogin(String? email) async {
    final service = ref.read(boutiFlowServiceProvider);
    final cloudSync = ref.read(cloudSyncServiceProvider);
    final revenueCat = ref.read(revenuecatServiceProvider);
    final appState = ref.read(appStateProvider.notifier);
    final languageCode = ref.read(appStateProvider).selectedLocale ??
        Localizations.localeOf(context).languageCode;

    Future<void> restoreLocalSession(String hotelId) async {
      final user = await service.restoreOrCreateSocialUser(
        email: email,
        languageCode: languageCode,
      );
      if (user != null) {
        appState.restoreSession(user, preferredLanguageCode: languageCode);
      }
      await revenueCat.identify(hotelId);
    }

    final localHotel = await service.getHotel();

    if (localHotel != null &&
        localHotel['name'] != null &&
        localHotel['name'].toString().isNotEmpty) {
      final hotelId = localHotel['id']?.toString() ?? '';
      await restoreLocalSession(hotelId);
      if (await revenueCat.hasProAccess()) {
        await cloudSync.linkCurrentUserToHotel(hotelId);
        await cloudSync.restoreFromCloud(hotelId);
      }
      if (mounted) context.go('/dashboard');
      return;
    }

    try {
      final cloudHotelId = await cloudSync.findHotelIdFromCloud();

      if (cloudHotelId != null) {
        await revenueCat.identify(cloudHotelId);
        final restoreResult = await revenueCat.restorePurchases();
        final hasPremium = restoreResult.hasPro ||
            await revenueCat.hasProAccess() ||
            await cloudSync.hasPremiumAccessFromCloud(cloudHotelId);

        await cloudSync.restoreBusinessProfileFromCloud(cloudHotelId);

        if (hasPremium) {
          await cloudSync.linkCurrentUserToHotel(cloudHotelId);
          await cloudSync.restoreFromCloud(cloudHotelId);
          await restoreLocalSession(cloudHotelId);
          if (mounted) context.go('/dashboard');
          return;
        }

        if (mounted) context.go('/paywall');
        return;
      }
    } catch (e) {
      debugPrint('Cloud restore check error: $e');
    }

    // New user - go to onboarding (hotel setup)
    if (mounted) context.go('/signup');
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NeoBrutalistTheme.black, width: 3),
          boxShadow: NeoBrutalistTheme.brutalistShadowSmall,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: NeoBrutalistTheme.white,
                ),
              )
            else ...[
              Icon(icon, color: NeoBrutalistTheme.white, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: NeoBrutalistTheme.titleMedium.copyWith(
                  color: NeoBrutalistTheme.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
