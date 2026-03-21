import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shows upgrade prompt when user hits Free tier limit
/// Updated: Now directly navigates to the Neo-Brutalist Paywall Page
class UpgradePrompt {
  static void show(
    BuildContext context, {
    required String feature,
    String? message,
  }) {
    context.push('/paywall');
  }
}
