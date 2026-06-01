import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/revenuecat_service.dart';
import 'paywall_provider.dart';

class PaywallPage extends ConsumerStatefulWidget {
  const PaywallPage({super.key});

  @override
  ConsumerState<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends ConsumerState<PaywallPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final locale = Localizations.maybeLocaleOf(context)?.languageCode;
      ref.read(paywallProvider.notifier).checkProStatus();
      ref.read(paywallProvider.notifier).loadProducts(locale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final paywallState = ref.watch(paywallProvider);
    final isPremium = paywallState.isPro;
    final activeProduct =
        paywallState.products.isNotEmpty ? paywallState.products.first : null;
    final isBusy = _isLoading || paywallState.isLoading;
    final productPrice = activeProduct?.storeProduct.priceString ?? '\$29.99';

    // If already premium, show success
    if (isPremium) {
      return Scaffold(
        backgroundColor: NeoBrutalistTheme.cream,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration:
                      NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
                  child: const Icon(Icons.check_rounded,
                      size: 50, color: NeoBrutalistTheme.white),
                ),
                const SizedBox(height: 24),
                Text(l10n.upper('paywallPremiumUser'),
                    style: NeoBrutalistTheme.headlineLarge),
                const SizedBox(height: 8),
                Text(
                  l10n.t('paywallAllUnlocked'),
                  style: NeoBrutalistTheme.bodyLarge
                      .copyWith(color: NeoBrutalistTheme.grey),
                ),
                const SizedBox(height: 32),
                NeoButton(
                  text: l10n.upper('continueAction'),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/login');
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: NeoBrutalistTheme.white,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: NeoBrutalistTheme.black, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back_rounded, size: 16),
                        const SizedBox(width: 4),
                        Text(l10n.upper('paywallContinueFree'),
                            style: NeoBrutalistTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Logo
              Container(
                width: 100,
                height: 100,
                decoration:
                    NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.purple),
                child: const Icon(Icons.star_rounded,
                    size: 50, color: NeoBrutalistTheme.white),
              ),
              const SizedBox(height: 24),

              Text(l10n.upper('paywallPremiumTitle'),
                  style: NeoBrutalistTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                l10n.t('paywallUnlockSubtitle'),
                style: NeoBrutalistTheme.bodyLarge
                    .copyWith(color: NeoBrutalistTheme.grey),
              ),
              const SizedBox(height: 32),

              // Benefits
              _BenefitCard(
                icon: Icons.bed_rounded,
                color: NeoBrutalistTheme.blue,
                title: l10n.upper('benefitUnlimited'),
                subtitle: l10n.t('benefitUnlimitedSubtitle'),
              ),
              const SizedBox(height: 12),
              _BenefitCard(
                icon: Icons.cloud_rounded,
                color: NeoBrutalistTheme.green,
                title: l10n.upper('benefitCloudSyncTitle'),
                subtitle: l10n.t('benefitCloudSyncSubtitle'),
              ),
              const SizedBox(height: 12),
              _BenefitCard(
                icon: Icons.analytics_rounded,
                color: NeoBrutalistTheme.orange,
                title: l10n.upper('benefitAdvancedReportsTitle'),
                subtitle: l10n.t('benefitAdvancedReportsSubtitle'),
              ),
              const SizedBox(height: 12),
              _BenefitCard(
                icon: Icons.picture_as_pdf_rounded,
                color: NeoBrutalistTheme.red,
                title: l10n.upper('benefitPdfTitle'),
                subtitle: l10n.t('benefitPdfSubtitle'),
              ),
              const SizedBox(height: 32),

              // Price
              Text(
                productPrice,
                style: NeoBrutalistTheme.displayLarge.copyWith(
                  color: NeoBrutalistTheme.purple,
                ),
              ),
              Text(
                l10n.t('paywallOneTimeLifetime'),
                style: NeoBrutalistTheme.bodyMedium
                    .copyWith(color: NeoBrutalistTheme.grey),
              ),
              const SizedBox(height: 32),

              // Purchase Button
              SizedBox(
                width: double.infinity,
                child: NeoButton(
                  text: isBusy
                      ? l10n.upper('loading')
                      : l10n.upper('paywallBuyNow'),
                  color: NeoBrutalistTheme.purple,
                  onPressed: isBusy ? null : () => _purchase(context, ref),
                ),
              ),
              const SizedBox(height: 16),

              // Restore
              GestureDetector(
                onTap: () async {
                  if (isBusy) return;
                  setState(() => _isLoading = true);
                  final restored = await ref
                      .read(paywallProvider.notifier)
                      .restorePurchases();
                  final error = ref.read(paywallProvider).error;
                  setState(() => _isLoading = false);

                  if (!context.mounted) return;
                  if (!restored && error != null && error.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _localizedPaywallError(context, error),
                        ),
                        backgroundColor: NeoBrutalistTheme.red,
                      ),
                    );
                  }
                },
                child: Text(
                  l10n.t('paywallRestorePurchases'),
                  style: NeoBrutalistTheme.bodyMedium.copyWith(
                    color: NeoBrutalistTheme.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _purchase(BuildContext context, WidgetRef ref) async {
    setState(() => _isLoading = true);

    try {
      final locale = Localizations.maybeLocaleOf(context)?.languageCode;
      final purchased = await ref
          .read(paywallProvider.notifier)
          .purchaseDefaultProduct(locale: locale);
      final error = ref.read(paywallProvider).error;

      if (!context.mounted) return;
      final l10n = context.l10n;

      if (purchased) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.t('paywallPurchaseSuccess')),
            backgroundColor: NeoBrutalistTheme.green,
          ),
        );
      } else if (error != null && error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_localizedPaywallError(context, error)),
            backgroundColor: NeoBrutalistTheme.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.tf('errorWithMessage', {'error': e})),
            backgroundColor: NeoBrutalistTheme.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _localizedPaywallError(BuildContext context, String error) {
    const messages = {
      RevenueCatService.errorNotConfigured: {
        'en': 'Purchases are not configured yet.',
        'tr': 'Satın alma henüz yapılandırılmadı.',
        'de': 'Käufe sind noch nicht konfiguriert.',
        'ru': 'Покупки еще не настроены.',
        'fr': 'Les achats ne sont pas encore configurés.',
        'es': 'Las compras aún no están configuradas.',
      },
      RevenueCatService.errorNoProducts: {
        'en': 'No purchasable product found for this paywall.',
        'tr': 'Bu paywall için satın alınabilir ürün bulunamadı.',
        'de': 'Für diese Paywall wurde kein kaufbares Produkt gefunden.',
        'ru': 'Для этого пейвола не найдено доступных для покупки продуктов.',
        'fr': 'Aucun produit achetable trouvé pour ce paywall.',
        'es': 'No se encontró ningún producto comprable para este paywall.',
      },
      RevenueCatService.errorPurchasePending: {
        'en': 'Purchase is pending.',
        'tr': 'Satın alma işlemi beklemede.',
        'de': 'Der Kauf ist ausstehend.',
        'ru': 'Покупка ожидает подтверждения.',
        'fr': 'L’achat est en attente.',
        'es': 'La compra está pendiente.',
      },
      RevenueCatService.errorUnknownPurchaseState: {
        'en': 'Unknown purchase state.',
        'tr': 'Bilinmeyen satın alma durumu.',
        'de': 'Unbekannter Kaufstatus.',
        'ru': 'Неизвестное состояние покупки.',
        'fr': 'État d’achat inconnu.',
        'es': 'Estado de compra desconocido.',
      },
    };

    final language = Localizations.localeOf(context).languageCode;
    final localized = messages[error]?[language] ?? messages[error]?['en'];
    if (localized != null) return localized;

    final l10n = context.l10n;
    return l10n.tf('errorWithMessage', {'error': error});
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _BenefitCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return NeoCard(
      color: NeoBrutalistTheme.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: NeoBrutalistTheme.black, width: 2),
            ),
            child: Icon(icon, color: NeoBrutalistTheme.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: NeoBrutalistTheme.titleMedium),
                Text(
                  subtitle,
                  style: NeoBrutalistTheme.bodyMedium
                      .copyWith(color: NeoBrutalistTheme.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: NeoBrutalistTheme.green),
        ],
      ),
    );
  }
}
