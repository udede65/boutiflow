import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/app_localizations.dart';

/// Neo-Brutalist Design System for BoutiFlow
/// Inspired by Habit Crusher app style

class NeoBrutalistTheme {
  // === COLORS ===

  // Primary Colors
  static const Color blue = Color(0xFF3B82F6);
  static const Color red = Color(0xFFEF4444);
  static const Color green = Color(0xFF22C55E);
  static const Color purple = Color(0xFFA855F7);
  static const Color yellow = Color(0xFFFCD34D);
  static const Color orange = Color(0xFFF97316);
  static const Color pink = Color(0xFFEC4899);
  static const Color cyan = Color(0xFF06B6D4);

  // Neutrals
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cream = Color(0xFFFFFBEB);
  static const Color grey = Color(0xFF6B7280);

  // === BORDERS ===
  static const double borderWidth = 4.0;
  static const double borderRadius = 16.0;

  static Border get blackBorder => Border.all(
        color: black,
        width: borderWidth,
      );

  // === SHADOWS ===
  static List<BoxShadow> get brutalistShadow => [
        const BoxShadow(
          color: black,
          offset: Offset(4, 4),
          blurRadius: 0,
        ),
      ];

  static List<BoxShadow> get brutalistShadowSmall => [
        const BoxShadow(
          color: black,
          offset: Offset(2, 2),
          blurRadius: 0,
        ),
      ];

  // === CARD DECORATIONS ===
  static BoxDecoration cardDecoration(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: blackBorder,
        boxShadow: brutalistShadow,
      );

  static BoxDecoration buttonDecoration(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: blackBorder,
        boxShadow: brutalistShadowSmall,
      );

  // === TEXT STYLES ===
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: black,
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: black,
        height: 1.1,
      );

  static TextStyle get headlineLarge => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: black,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: black,
      );

  static TextStyle get titleLarge => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: black,
      );

  static TextStyle get titleMedium => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: black,
      );

  static TextStyle get bodyLarge => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: black,
      );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: black,
      );

  static TextStyle get labelLarge => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: black,
        letterSpacing: 0.5,
      );

  // White text variants
  static TextStyle get displayLargeWhite => displayLarge.copyWith(color: white);
  static TextStyle get headlineLargeWhite =>
      headlineLarge.copyWith(color: white);
  static TextStyle get titleLargeWhite => titleLarge.copyWith(color: white);
  static TextStyle get bodyLargeWhite => bodyLarge.copyWith(color: white);

  // === THEME DATA ===
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: cream,
        colorScheme: const ColorScheme.light(
          primary: blue,
          secondary: yellow,
          surface: white,
          error: red,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: white,
          foregroundColor: black,
          elevation: 0,
          titleTextStyle: headlineMedium,
          centerTitle: false,
        ),
        textTheme: TextTheme(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          labelLarge: labelLarge,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: yellow,
            foregroundColor: black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: const BorderSide(color: black, width: borderWidth),
            ),
            elevation: 0,
            textStyle: titleMedium,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: const BorderSide(color: black, width: borderWidth),
            ),
            textStyle: titleMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: black, width: borderWidth),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: black, width: borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: blue, width: borderWidth),
          ),
          labelStyle: bodyMedium,
          hintStyle: bodyMedium.copyWith(color: grey),
        ),
        cardTheme: CardThemeData(
          color: white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(color: black, width: borderWidth),
          ),
        ),
      );
}

// === REUSABLE WIDGETS ===

/// Neo-Brutalist Card Widget
class NeoCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.color,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: NeoBrutalistTheme.cardDecoration(color),
        child: child,
      ),
    );
  }
}

/// Neo-Brutalist Stat Card
class NeoStatCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;
  final bool isWhiteText;

  const NeoStatCard({
    super.key,
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
    this.isWhiteText = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isWhiteText ? NeoBrutalistTheme.white : NeoBrutalistTheme.black;
    final l10n = AppLocalizations(Localizations.localeOf(context));

    return NeoCard(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: NeoBrutalistTheme.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: textColor, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: NeoBrutalistTheme.displayMedium.copyWith(color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.upperText(label),
            style: NeoBrutalistTheme.labelLarge.copyWith(
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Neo-Brutalist Button
class NeoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;

  const NeoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = NeoBrutalistTheme.yellow,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations(Localizations.localeOf(context));

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: NeoBrutalistTheme.buttonDecoration(color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: NeoBrutalistTheme.black),
              const SizedBox(width: 8),
            ],
            Text(
              l10n.upperText(text),
              style: NeoBrutalistTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
