import 'dart:ui';
import 'package:flutter/material.dart';

/// Glass Panel widget matching the new design system
/// Dark mode: blur(12px) + bg-opacity 70% + white/5 border
/// Light mode: solid white + subtle shadow
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.opacity = 0.7,
    this.borderRadius,
    this.padding,
    this.margin,
    this.border,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(16);
    
    if (isDark) {
      // Dark mode: Glassmorphism effect
      return Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F26).withOpacity(opacity),
                borderRadius: radius,
                border: border ?? Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              child: child,
            ),
          ),
        ),
      );
    } else {
      // Light mode: Solid card with shadow
      return Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: border ?? Border.all(
            color: Colors.black.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      );
    }
  }
}
