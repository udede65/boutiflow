import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/entities.dart';
import '../../providers/booking_providers.dart';
import '../../services/providers.dart';
import '../../core/localization/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../state/app_state.dart';
import 'finance_calculations.dart';
import 'finance_category_store.dart';

final paymentsProvider = FutureProvider.autoDispose<List<Payment>>((ref) async {
  final db = ref.read(boutiFlowServiceProvider).db;
  final payments = await db.select(db.payments).get();
  return payments
      .map((p) => Payment(
            id: p.id,
            bookingId: p.bookingId,
            amount: p.amount,
            date: p.date,
            method: p.method,
            type: p.type,
            notes: p.notes,
          ))
      .toList();
});

final expensesProvider = FutureProvider.autoDispose<List<Expense>>((ref) async {
  return ref.read(boutiFlowServiceProvider).fetchExpenses();
});

final customExpenseCategoriesProvider =
    FutureProvider.autoDispose<List<FinanceCategory>>((ref) async {
  final user = ref.watch(appStateProvider).user;
  if (user == null) return const [];
  return FinanceCategoryStore.loadExpenseCategories(user.hotelId);
});

class PaymentsPage extends ConsumerWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currencySymbol =
        getCurrencySymbol(ref.watch(appStateProvider).user?.currency ?? 'EUR');

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go('/dashboard');
                                    }
                                  },
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.t('finance'),
                                  style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: NeoBrutalistTheme.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: NeoBrutalistTheme.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: NeoBrutalistTheme.black,
                                width: 3,
                              ),
                            ),
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                color: NeoBrutalistTheme.yellow,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              labelColor: NeoBrutalistTheme.black,
                              unselectedLabelColor: NeoBrutalistTheme.grey,
                              labelStyle: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              dividerColor: Colors.transparent,
                              tabs: [
                                Tab(text: l10n.t('overview')),
                                Tab(text: l10n.t('income')),
                                Tab(text: l10n.t('expenses')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _OverviewTab(currencySymbol: currencySymbol),
                        _IncomeTab(currencySymbol: currencySymbol),
                        _ExpensesTab(currencySymbol: currencySymbol),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _FinanceFAB(),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab({required this.currencySymbol});

  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final paymentsAsync = ref.watch(paymentsProvider);
    final bookingsAsync = ref.watch(bookingsProvider);
    final expensesAsync = ref.watch(expensesProvider);

    if (paymentsAsync.isLoading ||
        bookingsAsync.isLoading ||
        expensesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (paymentsAsync.hasError ||
        bookingsAsync.hasError ||
        expensesAsync.hasError) {
      return Center(child: Text(l10n.t('errorLoadingFinancialData')));
    }

    final payments = paymentsAsync.value ?? [];
    final bookings = bookingsAsync.value ?? [];
    final allEntries = expensesAsync.value ?? [];
    final manualIncome = allEntries.where(isIncomeEntry).toList();
    final expenses =
        allEntries.where((entry) => !isIncomeEntry(entry)).toList();
    final totals = calculateFinanceTotals(
      payments: payments,
      bookings: bookings,
      manualIncome: manualIncome,
      expenses: expenses,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _SummaryCard(
          title: l10n.t('netProfit'),
          amount: totals.netProfit,
          currencySymbol: currencySymbol,
          icon: Icons.account_balance_wallet,
          color: totals.netProfit >= 0 ? Colors.blue : Colors.red,
          isMain: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: l10n.t('income'),
                amount: totals.totalIncome,
                currencySymbol: currencySymbol,
                icon: Icons.arrow_downward,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: l10n.t('expenses'),
                amount: totals.totalExpenses,
                currencySymbol: currencySymbol,
                icon: Icons.arrow_upward,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _BreakdownCard(
          bookingIncome: totals.bookingIncome,
          roomServiceIncome: totals.roomServiceIncome,
          manualIncome: totals.manualIncome,
          expenses: totals.totalExpenses,
          currencySymbol: currencySymbol,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.currencySymbol,
    required this.icon,
    required this.color,
    this.isMain = false,
  });

  final String title;
  final double amount;
  final String currencySymbol;
  final IconData icon;
  final Color color;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: NeoBrutalistTheme.cardDecoration(color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: NeoBrutalistTheme.white,
                size: isMain ? 32 : 26,
              ),
              if (isMain)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: NeoBrutalistTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: NeoBrutalistTheme.black, width: 2),
                  ),
                  child: Text(
                    context.l10n.t('total'),
                    style: NeoBrutalistTheme.labelLarge.copyWith(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: NeoBrutalistTheme.labelLarge.copyWith(
              color: NeoBrutalistTheme.white,
              fontSize: isMain ? 15 : 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(2)} $currencySymbol',
            style: NeoBrutalistTheme.headlineLarge.copyWith(
              color: NeoBrutalistTheme.white,
              fontSize: isMain ? 32 : 24,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({
    required this.bookingIncome,
    required this.roomServiceIncome,
    required this.manualIncome,
    required this.expenses,
    required this.currencySymbol,
  });

  final double bookingIncome;
  final double roomServiceIncome;
  final double manualIncome;
  final double expenses;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('simpleFinanceSummary'),
            style: NeoBrutalistTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _FinanceRow(
            color: Colors.blue,
            label: l10n.t('bookingIncome'),
            value: bookingIncome,
            currencySymbol: currencySymbol,
          ),
          _FinanceRow(
            color: Colors.cyan,
            label: l10n.t('roomServiceIncome'),
            value: roomServiceIncome,
            currencySymbol: currencySymbol,
          ),
          _FinanceRow(
            color: Colors.green,
            label: l10n.t('manualIncome'),
            value: manualIncome,
            currencySymbol: currencySymbol,
          ),
          _FinanceRow(
            color: Colors.red,
            label: l10n.t('expenses'),
            value: expenses,
            currencySymbol: currencySymbol,
          ),
        ],
      ),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  const _FinanceRow({
    required this.color,
    required this.label,
    required this.value,
    required this.currencySymbol,
  });

  final Color color;
  final String label;
  final double value;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: NeoBrutalistTheme.bodyMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 2,
            child: Text(
              _money(value, currencySymbol),
              textAlign: TextAlign.right,
              style: NeoBrutalistTheme.titleMedium.copyWith(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceFAB extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Positioned(
      bottom: 24,
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: Text(l10n.t('addManualIncome')),
                  onTap: () {
                    Navigator.pop(context);
                    _showTransactionDialog(context, ref, isIncome: true);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money_off, color: Colors.red),
                  title: Text(l10n.t('addExpense')),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddExpenseDialog(context, ref);
                  },
                ),
              ],
            ),
          );
        },
        label: Text(l10n.t('addTransaction')),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black,
      ),
    );
  }

  Future<void> _showTransactionDialog(
    BuildContext context,
    WidgetRef ref, {
    required bool isIncome,
  }) async {
    final l10n = context.l10n;
    final descController = TextEditingController();
    final amountController = TextEditingController();
    final user = ref.read(appStateProvider).user;
    var categories = isIncome
        ? financeIncomeCategories.toList()
        : [
            ...financeExpenseCategories,
            if (user != null)
              ...await FinanceCategoryStore.loadExpenseCategories(user.hotelId),
          ];
    var category = categories.first.code;
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title:
              Text(isIncome ? l10n.t('addManualIncome') : l10n.t('addExpense')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: isIncome
                      ? l10n.t('incomeDescription')
                      : l10n.t('expenseDescription'),
                ),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: l10n.t('amount')),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.t('category'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in categories)
                    ChoiceChip(
                      selected: category == item.code,
                      label: Text(item.label ?? l10n.t(item.labelKey)),
                      onSelected: (_) => setState(() => category = item.code),
                    ),
                  if (!isIncome)
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 18),
                      label: Text(l10n.t('addExpenseCategory')),
                      onPressed: () async {
                        final added =
                            await _showCustomCategoryDialog(context, ref);
                        if (added == null) return;
                        setState(() {
                          if (!categories.any((c) => c.code == added.code)) {
                            categories = [...categories, added];
                          }
                          category = added.code;
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.t('cancel'))),
            FilledButton(
              onPressed: () async {
                final desc = descController.text.trim();
                final amount = double.tryParse(
                        amountController.text.replaceAll(',', '.')) ??
                    0.0;
                if (desc.isNotEmpty && amount > 0) {
                  await ref.read(boutiFlowServiceProvider).createExpense(
                        description: desc,
                        amount: amount,
                        date: DateTime.now(),
                        category:
                            isIncome ? incomeCategoryCode(category) : category,
                      );
                  ref.invalidate(expensesProvider);
                  ref.invalidate(customExpenseCategoriesProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(l10n.t('save')),
            ),
          ],
        ),
      ),
    );

    descController.dispose();
    amountController.dispose();
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    _showTransactionDialog(context, ref, isIncome: false);
  }

  Future<FinanceCategory?> _showCustomCategoryDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = context.l10n;
    final user = ref.read(appStateProvider).user;
    if (user == null) return null;
    final controller = TextEditingController();
    final label = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('addExpenseCategory')),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.t('customCategoryName')),
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.t('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.t('save')),
          ),
        ],
      ),
    );
    controller.dispose();
    if (label == null || label.trim().isEmpty) return null;
    final category =
        await FinanceCategoryStore.addExpenseCategory(user.hotelId, label);
    ref.invalidate(customExpenseCategoriesProvider);
    return category;
  }
}

class _IncomeTab extends ConsumerWidget {
  const _IncomeTab({required this.currencySymbol});

  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsProvider);
    final bookingsAsync = ref.watch(bookingsProvider);
    final expensesAsync = ref.watch(expensesProvider);
    final l10n = context.l10n;

    if (paymentsAsync.isLoading ||
        bookingsAsync.isLoading ||
        expensesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (paymentsAsync.hasError ||
        bookingsAsync.hasError ||
        expensesAsync.hasError) {
      return Center(
        child: Text(
          l10n.tf('errorWithMessage', {
            'error': paymentsAsync.error ??
                bookingsAsync.error ??
                expensesAsync.error ??
                '',
          }),
        ),
      );
    }

    final incomeEntries =
        (expensesAsync.value ?? []).where(isIncomeEntry).toList();
    final movements = recentFinanceMovements(
      paymentsAsync.value ?? const [],
      incomeEntries,
      bookings: bookingsAsync.value ?? const [],
      incomeOnly: true,
    );

    if (movements.isEmpty) {
      return _FinanceEmptyState(
        icon: Icons.account_balance_wallet_rounded,
        title: l10n.t('noIncomeRecorded'),
        actionLabel: l10n.t('addTransaction'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: movements.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final movement = movements[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            child: const Icon(Icons.add, color: Colors.green),
          ),
          title: Text(movement.title, style: NeoBrutalistTheme.titleMedium),
          subtitle: Text(
            '${_categoryLabel(l10n, movement.category)} - ${DateFormat.yMMMd(l10n.locale.languageCode).format(movement.date)}',
            style: NeoBrutalistTheme.bodyMedium.copyWith(
              color: NeoBrutalistTheme.grey,
            ),
          ),
          trailing: Text(
            _money(movement.amount, currencySymbol),
            style: NeoBrutalistTheme.titleMedium.copyWith(
              color: NeoBrutalistTheme.green,
            ),
          ),
        );
      },
    );
  }
}

class _ExpensesTab extends ConsumerWidget {
  const _ExpensesTab({required this.currencySymbol});

  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final customCategoriesAsync = ref.watch(customExpenseCategoriesProvider);
    final l10n = context.l10n;

    if (expensesAsync.isLoading || customCategoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (expensesAsync.hasError || customCategoriesAsync.hasError) {
      return Center(
        child: Text(
          l10n.tf('errorWithMessage', {
            'error': expensesAsync.error ?? customCategoriesAsync.error ?? '',
          }),
        ),
      );
    }

    final expenses = (expensesAsync.value ?? [])
        .where((entry) => !isIncomeEntry(entry))
        .toList();
    final categories = [
      ...financeExpenseCategories,
      ...(customCategoriesAsync.value ?? const <FinanceCategory>[]),
    ];
    final breakdown = expenseByCategory(expenses);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _ExpenseCategorySummary(
          categories: categories,
          totalsByCategory: breakdown,
          currencySymbol: currencySymbol,
        ),
        const SizedBox(height: 14),
        if (expenses.isEmpty)
          _FinanceEmptyState(
            icon: Icons.receipt_long_rounded,
            title: l10n.t('noExpensesRecorded'),
            actionLabel: l10n.t('addTransaction'),
          )
        else
          ...expenses.map(
            (expense) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  child: const Icon(Icons.money_off, color: Colors.red),
                ),
                title: Text(
                  _money(expense.amount, currencySymbol),
                  style: NeoBrutalistTheme.titleMedium.copyWith(
                    color: NeoBrutalistTheme.red,
                  ),
                ),
                subtitle: Text(
                  '${expense.description} (${_categoryLabel(l10n, expense.category)})',
                  style: NeoBrutalistTheme.bodyMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.grey),
                  onPressed: () async {
                    await ref
                        .read(boutiFlowServiceProvider)
                        .deleteExpense(expense.id);
                    ref.invalidate(expensesProvider);
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ExpenseCategorySummary extends StatelessWidget {
  const _ExpenseCategorySummary({
    required this.categories,
    required this.totalsByCategory,
    required this.currencySymbol,
  });

  final List<FinanceCategory> categories;
  final Map<String, double> totalsByCategory;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('expenseCategories'),
            style: NeoBrutalistTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in categories)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: NeoBrutalistTheme.cream,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: NeoBrutalistTheme.black, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_categoryIcon(category.code), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${category.label ?? l10n.t(category.labelKey)} ${_money(totalsByCategory[category.code] ?? 0, currencySymbol)}',
                        style: NeoBrutalistTheme.labelLarge.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinanceEmptyState extends StatelessWidget {
  const _FinanceEmptyState({
    required this.icon,
    required this.title,
    required this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      children: [
        const SizedBox(height: 120),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration:
                    NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.yellow),
                child: Icon(icon, size: 32, color: NeoBrutalistTheme.black),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: NeoBrutalistTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                actionLabel,
                style: NeoBrutalistTheme.bodyMedium.copyWith(
                  color: NeoBrutalistTheme.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _money(double amount, String currencySymbol) {
  final clean = amount.truncateToDouble() == amount
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  return '$clean$currencySymbol';
}

String _categoryLabel(AppLocalizations l10n, String categoryCode) {
  final customLabel = customCategoryLabelFromCode(categoryCode);
  if (customLabel != null) return customLabel;
  return l10n.t(financeCategoryLabelKey(categoryCode));
}

IconData _categoryIcon(String categoryCode) {
  switch (normalizedFinanceCategory(categoryCode)) {
    case 'room':
      return Icons.king_bed_outlined;
    case 'service':
      return Icons.room_service_outlined;
    case 'food':
      return Icons.restaurant_outlined;
    case 'maintenance':
      return Icons.build_outlined;
    case 'cleaning':
      return Icons.cleaning_services_outlined;
    case 'supplies':
      return Icons.inventory_2_outlined;
    case 'utilities':
      return Icons.bolt_outlined;
    case 'salaries':
      return Icons.badge_outlined;
    case 'commission':
      return Icons.percent_outlined;
    default:
      return Icons.more_horiz;
  }
}
