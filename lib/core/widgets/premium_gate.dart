import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/paywall/paywall_provider.dart';
import '../../features/paywall/paywall_page.dart';
import '../localization/app_localizations.dart';

class PremiumGate extends ConsumerWidget {
  const PremiumGate({
    super.key,
    required this.child,
    this.message = 'This feature requires Premium.',
  });

  final Widget child;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isProProvider);
    final l10n = context.l10n;
    final resolvedMessage = message == 'This feature requires Premium.'
        ? l10n.t('upgradeToAccessReports')
        : message;

    if (isPremium) {
      return child;
    }

    return Stack(
      children: [
        // Blur or disable the child
        IgnorePointer(
          child: Opacity(
            opacity: 0.3,
            child: child,
          ),
        ),

        // Lock Overlay
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48, color: Colors.amber),
                const SizedBox(height: 16),
                Text(
                  l10n.t('premiumFeature'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  resolvedMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PaywallPage()),
                    );
                  },
                  icon: const Icon(Icons.star),
                  label: Text(l10n.t('upgradeNow')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
