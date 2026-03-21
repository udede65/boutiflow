import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_page.dart';
import '../features/auth/language_selection_screen.dart';
import '../features/auth/signup_page.dart';
import '../features/onboarding/onboarding_wizard.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/bookings/bookings_page.dart';
import '../features/bookings/booking_form_screen.dart';
import '../features/calendar/calendar_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/guests/guests_page.dart';
import '../features/guests/guest_form_screen.dart';
import '../features/messages/messages_page.dart';
import '../features/messages/template_form_screen.dart';
import '../features/reports/reports_page.dart';
import '../features/reports/analytics_page.dart';
import '../features/settings/settings_page.dart';
import '../features/settings/hotel_info_page.dart';
import '../features/settings/room_types_page.dart';
import '../features/shell/app_shell.dart';
import '../features/paywall/paywall_page.dart';
import '../features/housekeeping/housekeeping_page.dart';
import '../state/app_state.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _GoRouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final appState = ref.read(appStateProvider);
      final isAuthenticated = appState.isAuthenticated;
      final hasSelectedLanguage = appState.selectedLocale != null;
      final currentPath = state.matchedLocation;
      
      // Skip redirect for splash, onboarding, and paywall screens
      if (currentPath == '/splash' || currentPath == '/onboarding-intro' || currentPath == '/paywall') {
        return null;
      }
      
      final isLanguageSelection = currentPath == '/language-selection';
      final loggingIn = currentPath == '/login';
      final signingUp = currentPath == '/signup';

      // 1. If no language selected, force language selection
      // UNLESS we are already there.
      if (!hasSelectedLanguage) {
        if (isLanguageSelection) return null;
        return '/language-selection';
      }

      // 2. If language IS selected, but we are on language selection, go to login
      if (isLanguageSelection) {
        return '/login';
      }

      // 3. If not authenticated, go to login (unless already there or signing up)
      if (!isAuthenticated) {
        if (loggingIn || signingUp) return null;
        return '/login';
      }

      // 4. If authenticated and on login page, go to dashboard
      if (loggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding-intro',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/language-selection',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const OnboardingWizard(),
      ),
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/guests',
              builder: (context, state) => const GuestsPage(),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const GuestFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => GuestFormScreen(
                    guestId: state.pathParameters['id'],
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
              routes: [
                GoRoute(
                  path: 'hotel-info',
                  builder: (context, state) => const HotelInfoPage(),
                ),
                GoRoute(
                  path: 'room-types',
                  builder: (context, state) => const RoomTypesPage(),
                ),
              ],
            ),
          ]),
        ],
      ),
      // Non-tab routes still inside the shell area but not in branches
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const BookingsPage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return BookingFormScreen(
                initialRoomId: extra?['roomId'] as String?,
                initialDate: extra?['date'] as DateTime?,
              );
            },
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => BookingFormScreen(
              bookingId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/housekeeping',
        builder: (context, state) => const HousekeepingPage(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesPage(),
        routes: [
          GoRoute(
            path: 'templates/add',
            builder: (context, state) => const TemplateFormScreen(),
          ),
          GoRoute(
            path: 'templates/:id',
            builder: (context, state) => TemplateFormScreen(
              templateId: state.pathParameters['id'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsPage(),
        routes: [
          GoRoute(
            path: 'analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
        ],
      ),
    ],
  );
});

class _GoRouterNotifier extends ChangeNotifier {
  _GoRouterNotifier(this.ref) {
    ref.listen<AppState>(appStateProvider, (_, __) => notifyListeners());
  }

  final Ref ref;
}
