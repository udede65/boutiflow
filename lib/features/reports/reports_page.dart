import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';
import '../../core/widgets/premium_gate.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/premium_background.dart';
import 'occupancy_heatmap.dart';
import '../../core/widgets/page_wrapper.dart';
import 'widgets/revenue_by_source_chart.dart';
import 'widgets/occupancy_chart.dart';
import '../../core/services/plan_limits.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(reportsProvider);
    final appState = ref.watch(appStateProvider);
    final userProfile = appState.user;
    final l10n = context.l10n;
    final currencySymbol =
        getCurrencySymbol(ref.watch(appStateProvider).user?.currency ?? 'EUR');

    if (userProfile == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final hasAdvancedReports = PlanLimits.hasAdvancedReports(userProfile.plan);

    return PageWrapper(
      simpleHeader: false,
      bottomPadding: 0,
      body: PremiumBackground(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    l10n.t('reports'),
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (hasAdvancedReports)
                    IconButton(
                      onPressed: () {
                        final data =
                            reportsAsync.hasValue ? reportsAsync.value : null;
                        _exportReport(context, data);
                      },
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.white),
                      tooltip: l10n.t('exportCsv'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: hasAdvancedReports
                  ? reportsAsync.when(
                      data: (data) => ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        children: [
                          // Key Metrics Row
                          Row(
                            children: [
                              Expanded(
                                child: _MetricCard(
                                  label: l10n.t('bookings'),
                                  value: data.totalBookings.toString(),
                                  icon: Icons.book_online_rounded,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _MetricCard(
                                  label: l10n.t('revenue'),
                                  value:
                                      '${data.totalRevenue.toStringAsFixed(0)} $currencySymbol',
                                  icon: Icons.attach_money_rounded,
                                  color: const Color(0xFF34D399), // Emerald
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Occupancy Chart
                          Text(
                            l10n.t('currentOccupancy'),
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GlassContainer(
                            opacity: 0.05,
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            child: OccupancyChart(data: data.occupancySeries),
                          ),

                          const SizedBox(height: 32),

                          // Top Guests
                          Text(
                            l10n.t('topGuests'),
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (data.topGuests.isEmpty)
                            Text(l10n.t('noData'),
                                style: const TextStyle(color: Colors.white70))
                          else
                            ...data.topGuests.map(
                              (guest) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GlassContainer(
                                  opacity: 0.05,
                                  padding: const EdgeInsets.all(4),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.1)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: const Color(0xFFFFC107)
                                          .withValues(alpha: 0.2),
                                      child: Text(
                                        guest.name[0].toUpperCase(),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFFC107),
                                        ),
                                      ),
                                    ),
                                    title: Text(guest.name,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                    subtitle: Text(
                                        '${guest.visitCount} ${l10n.t('visits')}',
                                        style: const TextStyle(
                                            color: Colors.white54)),
                                    trailing: Text(
                                      '${guest.totalSpent.toStringAsFixed(0)} $currencySymbol',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 32),
                          Divider(color: Colors.white.withOpacity(0.1)),
                          const SizedBox(height: 16),

                          // Advanced Reports (Premium)
                          Row(
                            children: [
                              Icon(Icons.stars_rounded,
                                  color: Colors.amber[700]),
                              const SizedBox(width: 8),
                              Text(
                                l10n.t('advancedReports'),
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Revenue by Source
                          GlassContainer(
                            opacity: 0.05,
                            padding: const EdgeInsets.all(24),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.t('bookingSources'),
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                const SizedBox(height: 24),
                                RevenueBySourceChart(data: data.bookingSources),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const OccupancyHeatmap(),
                          const SizedBox(height: 32),
                        ],
                      ),
                      loading: () => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      error: (error, stackTrace) => Center(
                          child: Text(error.toString(),
                              style: const TextStyle(color: Colors.white))),
                    )
                  : PremiumGate(
                      message: l10n.t('upgradeToAccessReports'),
                      child: reportsAsync.when(
                        data: (data) => ListView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          children: [
                            // Key Metrics Row
                            // ...

                            const SizedBox(height: 32),

                            // Occupancy Chart
                            Text(
                              l10n.t('currentOccupancy'),
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GlassContainer(
                              opacity: 0.05,
                              padding: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.1)),
                              child: OccupancyChart(data: data.occupancySeries),
                            ),

                            const SizedBox(height: 32),

                            // Top Guests
                            // ...

                            const SizedBox(height: 32),
                            Divider(color: Colors.white.withOpacity(0.1)),
                            const SizedBox(height: 16),

                            // Advanced Reports (Premium)
                            Row(
                              children: [
                                Icon(Icons.stars_rounded,
                                    color: Colors.amber[700]),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.t('advancedReports'),
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Revenue by Source
                            GlassContainer(
                              opacity: 0.05,
                              padding: const EdgeInsets.all(24),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.t('bookingSources'),
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                  const SizedBox(height: 24),
                                  RevenueBySourceChart(
                                      data: data.bookingSources),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const OccupancyHeatmap(),
                            const SizedBox(height: 32),
                          ],
                        ),
                        loading: () => const Center(
                            child: CircularProgressIndicator.adaptive()),
                        error: (error, stackTrace) => Center(
                            child: Text(error.toString(),
                                style: const TextStyle(color: Colors.white))),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportReport(BuildContext context, ReportSummary? data) async {
    if (data == null) return;
    final l10n = context.l10n;

    final sb = StringBuffer();
    sb.writeln(l10n.t('reportSummary'));
    sb.writeln('Date,${DateTime.now().toIso8601String()}');
    sb.writeln('');

    sb.writeln(l10n.t('keyMetrics'));
    sb.writeln('${l10n.t('totalBookings')},${data.totalBookings}');
    sb.writeln('${l10n.t('totalRevenue')},${data.totalRevenue}');
    sb.writeln('');

    sb.writeln(l10n.t('bookingSources'));
    for (final entry in data.bookingSources.entries) {
      sb.writeln('${entry.key},${entry.value}');
    }
    sb.writeln('');

    sb.writeln(l10n.t('revenueByRoomType'));
    for (final entry in data.revenueByRoomType.entries) {
      sb.writeln('${entry.key},${entry.value}');
    }
    sb.writeln('');

    sb.writeln(l10n.t('topGuests'));
    sb.writeln('${l10n.t('name')},${l10n.t('visits')},${l10n.t('totalSpent')}');
    for (final guest in data.topGuests) {
      sb.writeln('${guest.name},${guest.visitCount},${guest.totalSpent}');
    }

    try {
      final directory = await getTemporaryDirectory();
      final file = File(
          '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(sb.toString());

      if (context.mounted) {
        await Share.shareXFiles([XFile(file.path)],
            text: l10n.t('reportShareText'));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.tf('failedExportReport', {'error': e}))),
        );
      }
    }
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.05,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
