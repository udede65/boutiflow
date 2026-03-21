import 'package:flutter/material.dart';

/// Theme extension for easy access to design system colors
/// Usage: final colors = Theme.of(context).appColors;
extension AppColorsExtension on ThemeData {
  AppColors get appColors => brightness == Brightness.dark 
      ? AppColors.dark() 
      : AppColors.light();
}

/// Design system colors
class AppColors {
  final Color primary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;

  const AppColors._({
    required this.primary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
  });

  factory AppColors.dark() => const AppColors._(
    primary: Color(0xFF2560E9),
    background: Color(0xFF111621),
    surface: Color(0xFF1C1F26),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9CA3AF),
    textMuted: Color(0xFF6B7280),
    border: Color(0x1AFFFFFF), // white 10%
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
  );

  factory AppColors.light() => const AppColors._(
    primary: Color(0xFF2560E9),
    background: Color(0xFFF6F6F8),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textMuted: Color(0xFF94A3B8),
    border: Color(0x14000000), // black 8%
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
  );
}
