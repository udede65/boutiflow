import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    // Try to load existing user from database
    final service = ref.read(boutiFlowServiceProvider);
    final existingUser = await service.getLoggedInUser();

    if (existingUser != null) {
      // User exists in DB - restore session and go to dashboard
      ref.read(appStateProvider.notifier).restoreSession(existingUser);

      if (mounted) {
        context.go('/dashboard');
      }
    } else if (hasSeenOnboarding) {
      // No user but has seen onboarding - go to login
      if (mounted) {
        context.go('/login');
      }
    } else {
      // First time user - show onboarding intro
      if (mounted) {
        context.go('/onboarding-intro');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: NeoBrutalistTheme.cardDecoration(
                          NeoBrutalistTheme.yellow),
                      child: const Icon(
                        Icons.hotel_rounded,
                        size: 60,
                        color: NeoBrutalistTheme.black,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
