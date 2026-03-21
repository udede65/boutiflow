import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../services/providers.dart';
import '../../core/widgets/glass_container.dart';
import '../../core/widgets/premium_background.dart';
import '../../core/widgets/premium_gate.dart';
import '../../state/app_state.dart';
import '../../core/services/plan_limits.dart';

final analyticsProvider = FutureProvider<ReportSummary>((ref) {
  final user = ref.watch(appStateProvider).user;
  if (user == null) {
    return ReportSummary(
      totalBookings: 0,
      totalRevenue: 0,
      occupancySeries: [],
      topGuests: [],
      monthlyRevenue: {},
      bookingSources: {},
      revenueByRoomType: {},
    );
  }
  return ref.watch(boutiFlowServiceProvider).fetchReports(user.hotelId);
});

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final analyticsAsync = ref.watch(analyticsProvider);
    final userPlan = ref.watch(appStateProvider).user?.plan ?? PlanType.free;
    final hasAdvancedReports = PlanLimits.hasAdvancedReports(userPlan);

    if (!hasAdvancedReports) {
      return Scaffold(
        body: PremiumBackground(
          child: SafeArea(
            child: PremiumGate(
              message: l10n.t('upgradeToAccessReports'),
              child: Center(
                child: Text(
                  l10n.t('reports'),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: PremiumBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  l10n.t('advancedAnalytics'),
                  style: GoogleFonts.inter(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    analyticsAsync.when(
                      data: (data) => Column(
                        children: [
                          _ChartSection(
                            title: l10n.t('bookingSources'),
                            child: _SourcePieChart(data: data.bookingSources),
                          ),
                          const SizedBox(height: 24),
                          _ChartSection(
                            title: l10n.t('revenueByRoomType'),
                            child:
                                _RevenueBarChart(data: data.revenueByRoomType),
                          ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Center(
                          child: Text(l10n.tf('errorWithMessage', {'error': e}),
                              style: const TextStyle(color: Colors.white))),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.1,
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SourcePieChart extends StatelessWidget {
  const _SourcePieChart({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
          child: Text(context.l10n.t('noDataAvailable'),
              style: const TextStyle(color: Colors.white54)));
    }

    final total = data.values.fold(0, (sum, val) => sum + val);
    int i = 0;
    final colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
    ];

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: data.entries.map((e) {
                final color = colors[i++ % colors.length];
                final percentage = (e.value / total * 100).toStringAsFixed(1);
                return PieChartSectionData(
                  color: color,
                  value: e.value.toDouble(),
                  title: '${percentage}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${e.key} (${e.value})',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RevenueBarChart extends StatelessWidget {
  const _RevenueBarChart({required this.data});

  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
          child: Text(context.l10n.t('noDataAvailable'),
              style: const TextStyle(color: Colors.white54)));
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 5
    final topEntries = sortedEntries.take(5).toList();
    final maxY = topEntries.isEmpty ? 100.0 : topEntries.first.value * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${topEntries[group.x.toInt()].key}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: rod.toY.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= topEntries.length)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    topEntries[value.toInt()]
                        .key
                        .substring(0, 3)
                        .toUpperCase(), // Shorten name
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                );
              },
            ),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: topEntries.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.value,
                color: const Color(0xFFFFC107),
                width: 20,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
