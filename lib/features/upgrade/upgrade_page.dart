import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroCard(
              title: l10n.t('upgradeTitle'),
              subtitle: l10n.t('upgradeSubtitle'),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.white),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: NeoBrutalistTheme.buttonDecoration(
                        NeoBrutalistTheme.purple),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: NeoBrutalistTheme.black,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium',
                          style: NeoBrutalistTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.t('upgradeSubtitle'),
                          style: NeoBrutalistTheme.bodyMedium.copyWith(
                            color: NeoBrutalistTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _BenefitTile(
              icon: Icons.hotel_rounded,
              text: l10n.t('benefitUnlimited'),
            ),
            const SizedBox(height: 10),
            _BenefitTile(
              icon: Icons.calendar_month_rounded,
              text: l10n.t('benefitCalendar'),
            ),
            const SizedBox(height: 10),
            _BenefitTile(
              icon: Icons.groups_rounded,
              text: l10n.t('benefitTeam'),
            ),
            const SizedBox(height: 10),
            _BenefitTile(
              icon: Icons.analytics_rounded,
              text: l10n.t('benefitReports'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: NeoButton(
                text: l10n.t('upgradeCta'),
                color: NeoBrutalistTheme.green,
                icon: Icons.arrow_upward_rounded,
                onPressed: () => context.push('/paywall'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                l10n.t('planLimit'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: NeoBrutalistTheme.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.yellow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                NeoBrutalistTheme.buttonDecoration(NeoBrutalistTheme.white),
            child: const Icon(
              Icons.bolt_rounded,
              color: NeoBrutalistTheme.black,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: NeoBrutalistTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: NeoBrutalistTheme.bodyLarge.copyWith(
              color: NeoBrutalistTheme.black.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.white),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration:
                NeoBrutalistTheme.buttonDecoration(NeoBrutalistTheme.green),
            child: Icon(icon, size: 20, color: NeoBrutalistTheme.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: NeoBrutalistTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: NeoBrutalistTheme.green,
          ),
        ],
      ),
    );
  }
}
