import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/language_preferences.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/boutiflow_service.dart';
import '../../services/notification_plan.dart';
import '../../services/notification_preferences.dart';
import '../../services/notification_service.dart';
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
    final savedLanguage = await LanguagePreferences.loadSelectedLanguage();
    if (savedLanguage != null) {
      ref.read(appStateProvider.notifier).setLanguage(savedLanguage);
    }

    // Try to load existing user from database
    final service = ref.read(boutiFlowServiceProvider);
    final existingUser = await service.getLoggedInUser();
    final startupRoute = resolveStartupRoute(
      hasLocalUser: existingUser != null,
      hasSeenOnboarding: hasSeenOnboarding,
      hasSelectedLanguage: ref.read(appStateProvider).selectedLocale != null,
    );

    if (existingUser != null) {
      // User exists in DB - restore session and go to dashboard
      ref
          .read(appStateProvider.notifier)
          .restoreSession(existingUser, preferredLanguageCode: savedLanguage);
      await _refreshLocalNotifications(service, existingUser);

      if (mounted) {
        context.go(startupRoute);
      }
      return;
    }

    if (mounted) {
      context.go(startupRoute);
    }
  }

  Future<void> _refreshLocalNotifications(
    BoutiFlowService service,
    UserProfile user,
  ) async {
    try {
      await notificationServiceProvider.init();
      final preferences = await NotificationPreferences.load();
      final bookings = await service.fetchBookings(user.hotelId);
      final plan = buildNotificationRefreshPlan(
        bookings: bookings,
        now: DateTime.now(),
        languageCode: user.languageCode,
        dailyBookingNotificationsEnabled:
            preferences.dailyBookingNotificationsEnabled,
        backupRemindersEnabled: preferences.backupRemindersEnabled,
        lastBackupAt: preferences.lastBackupAt,
      );
      await notificationServiceProvider.refreshScheduledNotifications(plan);
    } catch (e) {
      debugPrint('Notification refresh failed: $e');
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SplashBrand(tagline: l10n.t('appTagline')),
            ),
          );
        },
      ),
    );
  }
}

class SplashBrand extends StatelessWidget {
  const SplashBrand({super.key, required this.tagline});

  final String tagline;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: NeoBrutalistTheme.black,
                width: NeoBrutalistTheme.borderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: NeoBrutalistTheme.black,
                  offset: Offset(5, 5),
                  blurRadius: 0,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/app_icon.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'BOUTIFLOW',
            style: NeoBrutalistTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            tagline,
            style: NeoBrutalistTheme.bodyLarge.copyWith(
              color: NeoBrutalistTheme.grey,
            ),
          ),
        ],
      ),
    );
  }
}

String resolveStartupRoute({
  required bool hasLocalUser,
  required bool hasSeenOnboarding,
  required bool hasSelectedLanguage,
}) {
  if (hasLocalUser) return '/dashboard';
  if (!hasSelectedLanguage) return '/language-selection';
  return hasSeenOnboarding ? '/login' : '/onboarding-intro';
}
