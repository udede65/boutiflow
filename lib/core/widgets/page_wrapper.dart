import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    super.key,
    required this.body,
    this.title,
    this.headerActions,
    this.bottomPadding = 100.0,
    this.simpleHeader = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? headerActions;
  final double bottomPadding;
  final bool simpleHeader;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // New design system colors
    final bgColor = isDark ? const Color(0xFF111621) : const Color(0xFFF6F6F8);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    
    return Container(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (simpleHeader && (title != null || headerActions != null))
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    if (headerActions != null)
                      Row(children: headerActions!),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
