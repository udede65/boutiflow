import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../core/services/plan_limits.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../providers/booking_providers.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';
import '../finance/finance_calculations.dart';
import '../finance/payments_page.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  FinanceReportPeriod _period = FinanceReportPeriod.month;
  DateTime? _customStart;
  DateTime? _customEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appState = ref.watch(appStateProvider);
    final user = appState.user;

    if (user == null) {
      return const Scaffold(
        backgroundColor: NeoBrutalistTheme.cream,
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final hasPremiumReports = PlanLimits.hasAdvancedReports(user.plan);
    final currencySymbol = getCurrencySymbol(user.currency);
    final reportsAsync = ref.watch(reportsProvider);
    final bookingsAsync = ref.watch(bookingsProvider);
    final paymentsAsync = ref.watch(paymentsProvider);
    final expensesAsync = ref.watch(expensesProvider);

    final isLoading = reportsAsync.isLoading ||
        bookingsAsync.isLoading ||
        paymentsAsync.isLoading ||
        expensesAsync.isLoading;
    final error = reportsAsync.error ??
        bookingsAsync.error ??
        paymentsAsync.error ??
        expensesAsync.error;

    final range = financeDateRangeForPeriod(
      _period,
      customStart: _customStart,
      customEnd: _customEnd,
    );

    final bookings = bookingsAsync.value ?? const <Booking>[];
    final payments = paymentsAsync.value ?? const <Payment>[];
    final allEntries = expensesAsync.value ?? const <Expense>[];
    final manualIncome = allEntries.where(isIncomeEntry).toList();
    final expenses =
        allEntries.where((entry) => !isIncomeEntry(entry)).toList();
    final filteredBookings = _bookingsInRange(bookings, range);
    final filteredExpenses =
        expenses.where((e) => range.contains(e.date)).toList();
    final totals = calculateFinanceTotalsForRange(
      range: range,
      payments: payments,
      bookings: bookings,
      manualIncome: manualIncome,
      expenses: expenses,
    );
    final movements = recentFinanceMovements(
      payments,
      allEntries,
      bookings: bookings,
      bookingPaymentTitle: l10n.t('bookingIncome'),
    ).where((movement) => range.contains(movement.date)).take(5).toList();

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  _BackButton(onTap: () => context.go('/dashboard')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.t('reports'),
                      style: NeoBrutalistTheme.headlineLarge,
                    ),
                  ),
                  if (hasPremiumReports && !isLoading && error == null)
                    IconButton(
                      onPressed: () => _exportReport(
                        context,
                        range: range,
                        totals: totals,
                        report: reportsAsync.value,
                        bookings: filteredBookings,
                        expensesByCategory: expenseByCategory(filteredExpenses),
                      ),
                      icon: const Icon(Icons.download_rounded),
                      tooltip: l10n.t('exportCsv'),
                    ),
                ],
              ),
            ),
            _PeriodSelector(
              period: _period,
              hasPremiumReports: hasPremiumReports,
              customLabel: _period == FinanceReportPeriod.custom
                  ? _formatRange(context, range)
                  : l10n.t('categoryCustom'),
              onChanged: (period) => _setPeriod(period, hasPremiumReports),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              l10n.tf('errorWithMessage', {'error': error}),
                              style: NeoBrutalistTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                          children: [
                            Text(
                              _formatRange(context, range),
                              style: NeoBrutalistTheme.bodyMedium.copyWith(
                                color: NeoBrutalistTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _MetricGrid(
                              totals: totals,
                              bookingCount: filteredBookings.length,
                              currencySymbol: currencySymbol,
                            ),
                            const SizedBox(height: 18),
                            _BasicReportCard(
                              title: l10n.t('simpleFinanceSummary'),
                              rows: [
                                _ReportRowData(
                                  color: NeoBrutalistTheme.blue,
                                  label: l10n.t('bookingIncome'),
                                  value: totals.bookingIncome,
                                ),
                                _ReportRowData(
                                  color: NeoBrutalistTheme.cyan,
                                  label: l10n.t('manualIncome'),
                                  value: totals.manualIncome,
                                ),
                                _ReportRowData(
                                  color: NeoBrutalistTheme.red,
                                  label: l10n.t('expenses'),
                                  value: totals.totalExpenses,
                                ),
                              ],
                              currencySymbol: currencySymbol,
                            ),
                            const SizedBox(height: 18),
                            _RecentMovementsCard(
                              movements: movements,
                              currencySymbol: currencySymbol,
                            ),
                            const SizedBox(height: 20),
                            if (hasPremiumReports) ...[
                              _PremiumReports(
                                report: reportsAsync.value,
                                bookings: filteredBookings,
                                expenses: filteredExpenses,
                                currencySymbol: currencySymbol,
                              ),
                            ] else
                              _PremiumReportsPreview(),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setPeriod(
    FinanceReportPeriod period,
    bool hasPremiumReports,
  ) async {
    if (period != FinanceReportPeriod.custom) {
      setState(() => _period = period);
      return;
    }

    if (!hasPremiumReports) return;

    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDateRange: DateTimeRange(
        start: _customStart ?? DateTime(now.year, now.month, 1),
        end: _customEnd ?? now,
      ),
    );
    if (picked == null) return;
    setState(() {
      _period = FinanceReportPeriod.custom;
      _customStart = picked.start;
      _customEnd = picked.end;
    });
  }

  Future<void> _exportReport(
    BuildContext context, {
    required FinanceDateRange range,
    required FinanceTotals totals,
    required ReportSummary? report,
    required List<Booking> bookings,
    required Map<String, double> expensesByCategory,
  }) async {
    final l10n = context.l10n;
    final sb = StringBuffer()
      ..writeln(l10n.t('reportSummary'))
      ..writeln('${l10n.t('date')},${_formatRange(context, range)}')
      ..writeln('')
      ..writeln(l10n.t('keyMetrics'))
      ..writeln('${l10n.t('totalBookings')},${bookings.length}')
      ..writeln('${l10n.t('income')},${totals.totalIncome}')
      ..writeln('${l10n.t('expenses')},${totals.totalExpenses}')
      ..writeln('${l10n.t('netProfit')},${totals.netProfit}')
      ..writeln('')
      ..writeln(l10n.t('bookingSources'));

    for (final entry in _bookingSources(bookings).entries) {
      sb.writeln('${entry.key},${entry.value}');
    }

    sb
      ..writeln('')
      ..writeln(l10n.t('expenseBreakdown'));
    for (final entry in expensesByCategory.entries) {
      sb.writeln('${entry.key},${entry.value}');
    }

    if (report != null) {
      sb
        ..writeln('')
        ..writeln(l10n.t('topGuests'))
        ..writeln(
            '${l10n.t('name')},${l10n.t('visits')},${l10n.t('totalSpent')}');
      for (final guest in report.topGuests) {
        sb.writeln('${guest.name},${guest.visitCount},${guest.totalSpent}');
      }
    }

    try {
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.csv',
      );
      await file.writeAsString(sb.toString());

      if (context.mounted) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: l10n.t('reportShareText'),
          ),
        );
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

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.period,
    required this.hasPremiumReports,
    required this.customLabel,
    required this.onChanged,
  });

  final FinanceReportPeriod period;
  final bool hasPremiumReports;
  final String customLabel;
  final ValueChanged<FinanceReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final options = [
      (FinanceReportPeriod.today, l10n.t('today'), Icons.today_rounded),
      (FinanceReportPeriod.week, l10n.t('weekShort'), Icons.view_week_rounded),
      (
        FinanceReportPeriod.month,
        l10n.t('monthShort'),
        Icons.calendar_month_rounded
      ),
      if (hasPremiumReports)
        (FinanceReportPeriod.custom, customLabel, Icons.date_range_rounded),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final option in options) ...[
            _PeriodChip(
              label: option.$2,
              icon: option.$3,
              selected: period == option.$1,
              onTap: () => onChanged(option.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? NeoBrutalistTheme.yellow : NeoBrutalistTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: NeoBrutalistTheme.black, width: 3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: NeoBrutalistTheme.labelLarge.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({
    required this.totals,
    required this.bookingCount,
    required this.currencySymbol,
  });

  final FinanceTotals totals;
  final int bookingCount;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        _ReportMetricCard(
          label: l10n.t('netProfit'),
          value: _money(totals.netProfit, currencySymbol),
          icon: Icons.account_balance_wallet_rounded,
          color: totals.netProfit >= 0
              ? NeoBrutalistTheme.blue
              : NeoBrutalistTheme.red,
          wide: true,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ReportMetricCard(
                label: l10n.t('income'),
                value: _money(totals.totalIncome, currencySymbol),
                icon: Icons.south_west_rounded,
                color: NeoBrutalistTheme.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReportMetricCard(
                label: l10n.t('expenses'),
                value: _money(totals.totalExpenses, currencySymbol),
                icon: Icons.north_east_rounded,
                color: NeoBrutalistTheme.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ReportMetricCard(
          label: l10n.t('totalBookings'),
          value: bookingCount.toString(),
          icon: Icons.book_online_rounded,
          color: NeoBrutalistTheme.purple,
          wide: true,
        ),
      ],
    );
  }
}

class _ReportMetricCard extends StatelessWidget {
  const _ReportMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.wide = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: NeoBrutalistTheme.cardDecoration(color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: NeoBrutalistTheme.white, size: 26),
          const SizedBox(height: 18),
          Text(
            value,
            style: NeoBrutalistTheme.headlineLargeWhite,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: NeoBrutalistTheme.labelLarge.copyWith(
              color: NeoBrutalistTheme.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BasicReportCard extends StatelessWidget {
  const _BasicReportCard({
    required this.title,
    required this.rows,
    required this.currencySymbol,
  });

  final String title;
  final List<_ReportRowData> rows;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: title,
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: row.color,
                      borderRadius: BorderRadius.circular(4),
                      border:
                          Border.all(color: NeoBrutalistTheme.black, width: 2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      row.label,
                      style: NeoBrutalistTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    _money(row.value, currencySymbol),
                    style: NeoBrutalistTheme.titleMedium,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentMovementsCard extends StatelessWidget {
  const _RecentMovementsCard({
    required this.movements,
    required this.currencySymbol,
  });

  final List<FinanceMovement> movements;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _ReportCard(
      title: l10n.t('recentTransactions'),
      child: movements.isEmpty
          ? Text(
              l10n.t('noDataAvailable'),
              style: NeoBrutalistTheme.bodyMedium.copyWith(
                color: NeoBrutalistTheme.grey,
              ),
            )
          : Column(
              children: [
                for (final movement in movements)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: movement.isIncome
                          ? NeoBrutalistTheme.green
                          : NeoBrutalistTheme.red,
                      child: Icon(
                        movement.isIncome
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                        color: NeoBrutalistTheme.white,
                      ),
                    ),
                    title: Text(
                      movement.title,
                      style: NeoBrutalistTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd(l10n.locale.languageCode)
                          .format(movement.date),
                      style: NeoBrutalistTheme.bodyMedium.copyWith(
                        color: NeoBrutalistTheme.grey,
                      ),
                    ),
                    trailing: Text(
                      _money(movement.amount, currencySymbol),
                      style: NeoBrutalistTheme.titleMedium.copyWith(
                        color: movement.isIncome
                            ? NeoBrutalistTheme.green
                            : NeoBrutalistTheme.red,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PremiumReports extends StatelessWidget {
  const _PremiumReports({
    required this.report,
    required this.bookings,
    required this.expenses,
    required this.currencySymbol,
  });

  final ReportSummary? report;
  final List<Booking> bookings;
  final List<Expense> expenses;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sourceTotals = _bookingSources(bookings);
    final roomTypeRevenue = _revenueByRoomType(bookings, l10n);
    final expenseTotals = expenseByCategory(expenses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: l10n.t('advancedReports'), premium: true),
        const SizedBox(height: 12),
        _KeyValueCard(
          title: l10n.t('bookingSources'),
          entries:
              sourceTotals.map((key, value) => MapEntry(key, value.toDouble())),
          valueFormatter: (value) => value.toStringAsFixed(0),
        ),
        const SizedBox(height: 14),
        _KeyValueCard(
          title: l10n.t('revenueByRoomType'),
          entries: roomTypeRevenue,
          valueFormatter: (value) => _money(value, currencySymbol),
        ),
        const SizedBox(height: 14),
        _KeyValueCard(
          title: l10n.t('expenseBreakdown'),
          entries: expenseTotals,
          valueFormatter: (value) => _money(value, currencySymbol),
        ),
        const SizedBox(height: 14),
        _TopGuestsCard(
          guests: report?.topGuests ?? const <Guest>[],
          currencySymbol: currencySymbol,
        ),
      ],
    );
  }
}

class _PremiumReportsPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.purple),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: NeoBrutalistTheme.yellow),
              const SizedBox(width: 8),
              Text(
                l10n.t('premiumFinanceReports'),
                style: NeoBrutalistTheme.titleLargeWhite,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.t('premiumFinanceReportsHint'),
            style: NeoBrutalistTheme.bodyMedium.copyWith(
              color: NeoBrutalistTheme.white,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _LockedPill(label: l10n.t('categoryCustom')),
              _LockedPill(label: l10n.t('expenseBreakdown')),
              _LockedPill(label: l10n.t('bookingSources')),
              _LockedPill(label: l10n.t('exportCsv')),
            ],
          ),
        ],
      ),
    );
  }
}

class _LockedPill extends StatelessWidget {
  const _LockedPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: NeoBrutalistTheme.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: NeoBrutalistTheme.black, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_rounded, size: 14),
          const SizedBox(width: 5),
          Text(label,
              style: NeoBrutalistTheme.labelLarge.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class _KeyValueCard extends StatelessWidget {
  const _KeyValueCard({
    required this.title,
    required this.entries,
    required this.valueFormatter,
  });

  final String title;
  final Map<String, double> entries;
  final String Function(double value) valueFormatter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _ReportCard(
      title: title,
      child: entries.isEmpty
          ? Text(
              l10n.t('noDataAvailable'),
              style: NeoBrutalistTheme.bodyMedium.copyWith(
                color: NeoBrutalistTheme.grey,
              ),
            )
          : Column(
              children: [
                for (final entry in entries.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: NeoBrutalistTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          valueFormatter(entry.value),
                          style: NeoBrutalistTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _TopGuestsCard extends StatelessWidget {
  const _TopGuestsCard({
    required this.guests,
    required this.currencySymbol,
  });

  final List<Guest> guests;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _ReportCard(
      title: l10n.t('topGuests'),
      child: guests.isEmpty
          ? Text(
              l10n.t('noDataAvailable'),
              style: NeoBrutalistTheme.bodyMedium.copyWith(
                color: NeoBrutalistTheme.grey,
              ),
            )
          : Column(
              children: [
                for (final guest in guests)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: NeoBrutalistTheme.yellow,
                      child: Text(
                        guest.name.isEmpty ? '?' : guest.name[0].toUpperCase(),
                        style: NeoBrutalistTheme.titleMedium,
                      ),
                    ),
                    title:
                        Text(guest.name, style: NeoBrutalistTheme.titleMedium),
                    subtitle: Text(
                      '${guest.visitCount} ${l10n.t('visits')}',
                      style: NeoBrutalistTheme.bodyMedium.copyWith(
                        color: NeoBrutalistTheme.grey,
                      ),
                    ),
                    trailing: Text(
                      _money(guest.totalSpent, currencySymbol),
                      style: NeoBrutalistTheme.titleMedium,
                    ),
                  ),
              ],
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.premium = false});

  final String title;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: NeoBrutalistTheme.headlineMedium),
        if (premium) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: NeoBrutalistTheme.yellow,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: NeoBrutalistTheme.black, width: 2),
            ),
            child: Text(
              context.l10n.t('premium'),
              style: NeoBrutalistTheme.labelLarge.copyWith(fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: NeoBrutalistTheme.titleLarge),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ReportRowData {
  const _ReportRowData({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final double value;
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NeoBrutalistTheme.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: NeoBrutalistTheme.black, width: 3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.arrow_back, color: NeoBrutalistTheme.black),
        ),
      ),
    );
  }
}

List<Booking> _bookingsInRange(List<Booking> bookings, FinanceDateRange range) {
  return bookings
      .where(
        (booking) =>
            booking.status != BookingStatus.cancelled &&
            range.contains(booking.checkIn),
      )
      .toList();
}

Map<String, int> _bookingSources(List<Booking> bookings) {
  final totals = <String, int>{};
  for (final booking in bookings) {
    totals[booking.source] = (totals[booking.source] ?? 0) + 1;
  }
  return totals;
}

Map<String, double> _revenueByRoomType(
  List<Booking> bookings,
  AppLocalizations l10n,
) {
  final totals = <String, double>{};
  for (final booking in bookings) {
    final name = booking.room.type?.name ?? l10n.t('unassignedRoomType');
    totals[name] = (totals[name] ?? 0) + (booking.priceTotal ?? 0);
  }
  return totals;
}

String _formatRange(BuildContext context, FinanceDateRange range) {
  final languageCode = context.l10n.locale.languageCode;
  final formatter = DateFormat.MMMd(languageCode);
  final inclusiveEnd = range.endExclusive.subtract(const Duration(days: 1));
  if (range.start == inclusiveEnd) return formatter.format(range.start);
  return '${formatter.format(range.start)} - ${formatter.format(inclusiveEnd)}';
}

String _money(double amount, String currencySymbol) {
  final clean = amount.truncateToDouble() == amount
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  return '$clean$currencySymbol';
}
