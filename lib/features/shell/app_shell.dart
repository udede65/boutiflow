import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../core/widgets/banner_ad_widget.dart';
import '../paywall/paywall_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _icons = [
    Icons.grid_view_rounded,
    Icons.calendar_month_rounded,
    Icons.group_rounded,
    Icons.settings_rounded,
  ];

  static const _labelKeys = ['home', 'calendar', 'guests', 'settings'];

  static const _colors = [
    NeoBrutalistTheme.blue,
    NeoBrutalistTheme.orange,
    NeoBrutalistTheme.purple,
    NeoBrutalistTheme.green,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedIndex = navigationShell.currentIndex;
    final isPro = ref.watch(isProProvider);

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
            decoration: BoxDecoration(
              color: NeoBrutalistTheme.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: NeoBrutalistTheme.black,
                width: NeoBrutalistTheme.borderWidth,
              ),
              boxShadow: const [
                BoxShadow(
                  color: NeoBrutalistTheme.black,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (i) {
                  final isSelected = i == selectedIndex;
                  final itemColor = _colors[i];
                  final labelKey = _labelKeys[i];

                  return GestureDetector(
                    onTap: () => navigationShell.goBranch(
                      i,
                      initialLocation: i == selectedIndex,
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSelected ? 16 : 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? itemColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: NeoBrutalistTheme.black, width: 2)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _icons[i],
                            size: 24,
                            color: isSelected
                                ? NeoBrutalistTheme.white
                                : NeoBrutalistTheme.grey,
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Text(
                              l10n.upperText(l10n.t(labelKey)),
                              style: NeoBrutalistTheme.labelLarge.copyWith(
                                color: NeoBrutalistTheme.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          if (!isPro && selectedIndex != 3) const BannerAdWidget(),
        ],
      ),
    );
  }
}
