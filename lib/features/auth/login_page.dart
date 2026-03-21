import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../state/app_state.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/supabase_auth_service.dart';
import '../../services/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;
  String? _errorMessage;
  final SupabaseAuthService _authService = SupabaseAuthService();

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
                    color: NeoBrutalistTheme.red.withOpacity(0.1),
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

              // === SOCIAL LOGIN BUTTONS ===
              NeoCard(
                color: NeoBrutalistTheme.white,
                child: Column(
                  children: [
                    // Google Sign-In
                    _SocialLoginButton(
                      icon: Icons.g_mobiledata_rounded,
                      label: l10n.t('loginWithGoogle'),
                      color: NeoBrutalistTheme.red,
                      isLoading: _isLoading,
                      onTap: _signInWithGoogle,
                    ),
                    const SizedBox(height: 16),

                    // Apple Sign-In (only on iOS or for testing)
                    if (Platform.isIOS || Platform.isMacOS) ...[
                      _SocialLoginButton(
                        icon: Icons.apple_rounded,
                        label: l10n.t('loginWithApple'),
                        color: NeoBrutalistTheme.black,
                        isLoading: _isLoading,
                        onTap: _signInWithApple,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                                color:
                                    NeoBrutalistTheme.black.withOpacity(0.2))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(l10n.t('or'),
                              style: NeoBrutalistTheme.bodyMedium
                                  .copyWith(color: NeoBrutalistTheme.grey)),
                        ),
                        Expanded(
                            child: Divider(
                                color:
                                    NeoBrutalistTheme.black.withOpacity(0.2))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Demo/Dev Login
                    GestureDetector(
                      onTap: _isLoading ? null : _devLogin,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: NeoBrutalistTheme.cream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: NeoBrutalistTheme.black, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.developer_mode, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.t('demoAccountLogin'),
                                style: NeoBrutalistTheme.labelLarge),
                          ],
                        ),
                      ),
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

  Future<void> _signInWithGoogle() async {
    final l10n = context.l10n;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.signInWithGoogle();

      if (result.success) {
        // Check if user is new (needs onboarding) or existing
        await _handleSuccessfulLogin(result.email);
      } else {
        // Show error even if cancelled
        final errorMsg = result.error ?? l10n.t('signInFailedOrCancelled');
        setState(() => _errorMessage = errorMsg);
      }
    } catch (e) {
      setState(() => _errorMessage = l10n.tf('unexpectedError', {'error': e}));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    final l10n = context.l10n;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.signInWithApple();

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
    // First check if hotel exists locally (returning user on same device)
    final localHotel = await ref.read(boutiFlowServiceProvider).getHotel();

    if (localHotel != null &&
        localHotel['name'] != null &&
        localHotel['name'].toString().isNotEmpty) {
      // Existing local user - go to dashboard
      if (mounted) context.go('/dashboard');
      return;
    }

    // No local data - try to restore from Supabase cloud
    try {
      final cloudSync = ref.read(cloudSyncServiceProvider);
      final cloudHotelId = await cloudSync.findHotelIdFromCloud();

      if (cloudHotelId != null) {
        // User has cloud data - restore it and show paywall for premium
        final result = await cloudSync.restoreFromCloud(cloudHotelId);
        if (result.success) {
          // Data restored - show paywall to encourage premium/restore purchases
          if (mounted) {
            context.go('/paywall');
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Cloud restore check error: $e');
    }

    // New user - go to onboarding (hotel setup)
    if (mounted) context.go('/signup');
  }

  Future<void> _devLogin() async {
    final l10n = context.l10n;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifier = ref.read(appStateProvider.notifier);
      bool success = await notifier.signIn(
        email: 'dev@boutiflow.com',
        password: 'devpassword',
      );

      if (!success) {
        await notifier.register(
          email: 'dev@boutiflow.com',
          password: 'devpassword',
          hotelName: 'Demo Otel',
          languageCode: ref.read(appStateProvider).selectedLocale ?? 'en',
        );
        success = ref.read(appStateProvider).isAuthenticated;
      }

      if (mounted) {
        if (success) {
          context.go('/dashboard');
        } else {
          setState(() => _errorMessage = l10n.t('demoLoginFailed'));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(
            () => _errorMessage = l10n.tf('errorWithMessage', {'error': e}));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
