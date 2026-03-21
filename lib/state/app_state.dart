import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/providers.dart';
import '../services/adapty_service.dart';

import '../core/models/entities.dart';

import 'package:flutter/material.dart';

class AppState {
  const AppState({
    required this.isAuthenticated,
    this.user,
    this.selectedLocale,
    this.themeMode = ThemeMode.system,
    this.backupReminders = true,
  });

  final bool isAuthenticated;
  final UserProfile? user;
  final String? selectedLocale;
  final ThemeMode themeMode;
  final bool backupReminders;

  AppState copyWith({
    bool? isAuthenticated,
    UserProfile? user,
    String? selectedLocale,
    ThemeMode? themeMode,
    bool? backupReminders,
  }) {
    return AppState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      selectedLocale: selectedLocale ?? this.selectedLocale,
      themeMode: themeMode ?? this.themeMode,
      backupReminders: backupReminders ?? this.backupReminders,
    );
  }
}

class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() => const AppState(isAuthenticated: false);

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final service = ref.read(boutiFlowServiceProvider);
    final user = await service.loginUser(email, password);

    if (user != null) {
      state = state.copyWith(
        isAuthenticated: true,
        user: user,
        selectedLocale: user.languageCode,
      );
      unawaited(ref.read(adaptyServiceProvider).identify(user.hotelId));
      return true;
    }
    return false;
  }

  Future<void> register({
    required String email,
    required String password,
    required String hotelName,
    required String languageCode,
  }) async {
    final service = ref.read(boutiFlowServiceProvider);
    await service.registerUser(
      email: email,
      password: password,
      hotelName: hotelName,
      languageCode: languageCode,
    );

    // Auto login after register
    await signIn(email: email, password: password);
  }

  /// Restore session from existing user profile (for app restart)
  void restoreSession(UserProfile user) {
    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      selectedLocale: user.languageCode,
    );
    unawaited(ref.read(adaptyServiceProvider).identify(user.hotelId));
  }

  void signOut() {
    state = const AppState(isAuthenticated: false);
    unawaited(ref.read(adaptyServiceProvider).logout());
  }

  void changeLanguage(String languageCode) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(
      user: user.copyWith(languageCode: languageCode),
      selectedLocale: languageCode,
    );
  }

  void setLanguage(String languageCode) {
    state = state.copyWith(selectedLocale: languageCode);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void upgradePlan(PlanType plan) {
    final user = state.user;
    if (user == null) return;
    state = state.copyWith(user: user.copyWith(plan: plan));
    unawaited(_persistPlan(plan));
  }

  Future<void> _persistPlan(PlanType plan) async {
    try {
      await ref.read(boutiFlowServiceProvider).updateCurrentUserPlan(plan.name);
    } catch (_) {
      // Keep local state even if persistence fails.
    }
  }

  void updateUserProfile(UserProfile user) {
    state = state.copyWith(user: user);
  }

  void toggleBackupReminders(bool enabled) {
    state = state.copyWith(backupReminders: enabled);
  }
}

final appStateProvider =
    NotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);
