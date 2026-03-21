import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../providers/repository_providers.dart';
import '../../../settings/data/models/profile_model.dart';

/// Auth state containing user and profile
class AuthState {
  final User? user;
  final ProfileModel? profile;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.profile,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    User? user,
    ProfileModel? profile,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth controller for managing authentication state
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final client = ref.watch(supabaseClientProvider);
    final user = client.auth.currentUser;
    
    // Listen to auth state changes
    client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _onSignIn(data.session?.user);
      } else if (data.event == AuthChangeEvent.signedOut) {
        state = const AuthState();
      }
    });

    if (user != null) {
      _loadProfile();
    }

    return AuthState(user: user);
  }

  void _onSignIn(User? user) {
    state = state.copyWith(user: user);
    if (user != null) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      state = state.copyWith(profile: profile);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load profile: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(supabaseClientProvider).auth.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Sign out failed: $e');
    }
  }

  /// Refresh the current user's profile
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  /// Update profile settings
  Future<void> updateProfile({
    String? currencySymbol,
    String? appLanguage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedProfile = await ref.read(profileRepositoryProvider).updateProfile(
        currencySymbol: currencySymbol,
        appLanguage: appLanguage,
      );
      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Update failed: $e');
    }
  }
}

/// Auth controller provider (manual, not generated)
final authControllerProvider = NotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

/// Simple provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).isAuthenticated;
});

/// Provider for current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authControllerProvider).user;
});

/// Provider for current profile
final currentProfileProvider = Provider<ProfileModel?>((ref) {
  return ref.watch(authControllerProvider).profile;
});
