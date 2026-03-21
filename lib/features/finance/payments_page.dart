import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/entities.dart';
import '../../services/providers.dart';
import '../../core/localization/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/page_wrapper.dart';
import '../../state/app_state.dart';

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

class PaymentsPage extends ConsumerWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currencySymbol =
        getCurrencySymbol(ref.watch(appStateProvider).user?.currency ?? 'EUR');

    return PageWrapper(
      simpleHeader: false,
      bottomPadding: 0,
      body: Stack(
        children: [
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // Custom Header with TabBar
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.t('finance'),
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: const Color(0xFFFFC107),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.white70,
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
    final expensesAsync = ref.watch(expensesProvider);

    if (paymentsAsync.isLoading || expensesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (paymentsAsync.hasError || expensesAsync.hasError) {
      return Center(child: Text(l10n.t('errorLoadingFinancialData')));
    }

    final payments = paymentsAsync.value ?? [];
    final expenses = expensesAsync.value ?? [];

    final totalIncome = payments.fold(0.0, (sum, p) => sum + p.amount);
    final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final netProfit = totalIncome - totalExpenses;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _SummaryCard(
          title: l10n.t('netProfit'),
          amount: netProfit,
          currencySymbol: currencySymbol,
          icon: Icons.account_balance_wallet,
          color: netProfit >= 0 ? Colors.blue : Colors.red,
          isMain: true,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: l10n.t('income'),
                amount: totalIncome,
                currencySymbol: currencySymbol,
                icon: Icons.arrow_downward,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _SummaryCard(
                title: l10n.t('expenses'),
                amount: totalExpenses,
                currencySymbol: currencySymbol,
                icon: Icons.arrow_upward,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(l10n.t('recentTransactions'),
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        // Combine and sort recent transactions could go here
        Center(
            child: Text(l10n.t('recentActivityChartSoon'),
                style: const TextStyle(color: Colors.grey))),
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
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: isMain ? 32 : 24),
              if (isMain)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.t('total'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
              fontSize: isMain ? 16 : 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(2)} $currencySymbol',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: isMain ? 32 : 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceFAB extends ConsumerWidget {
// ... existing _FinanceFAB
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // ... existing implementation
    // Note: Since we removed Scaffold, we need to handle FAB differently.
    // Ideally PageWrapper should support FAB or we use a Stack.
    // For now, let's return a simple button that triggers the bottom sheet.
    // Or better, wrap the PageWrapper body in a Stack.
    // But PageWrapper is already a Container.
    // Let's modify PaymentsPage to use a Stack for the FAB.
    return Positioned(
      bottom: 100, // Above nav bar
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
                  title: Text(l10n.t('addIncomeBookingPayment')),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(l10n.t('goToBookingToAddPayment'))),
                    );
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

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'other';
    const categories = [
      'maintenance',
      'supplies',
      'utilities',
      'salaries',
      'other'
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.t('addExpense')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: l10n.t('description')),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: l10n.t('amount')),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: category,
                items: categories
                    .map((c) => DropdownMenuItem(
                        value: c, child: Text(_categoryLabel(l10n, c))))
                    .toList(),
                onChanged: (v) => setState(() => category = v!),
                decoration: InputDecoration(labelText: l10n.t('category')),
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
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (desc.isNotEmpty && amount > 0) {
                  await ref.read(boutiFlowServiceProvider).createExpense(
                        description: desc,
                        amount: amount,
                        date: DateTime.now(),
                        category: category,
                      );
                  ref.invalidate(expensesProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(l10n.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String categoryCode) {
    switch (categoryCode) {
      case 'maintenance':
        return l10n.t('categoryMaintenance');
      case 'supplies':
        return l10n.t('categorySupplies');
      case 'utilities':
        return l10n.t('categoryUtilities');
      case 'salaries':
        return l10n.t('categorySalaries');
      default:
        return l10n.t('categoryOther');
    }
  }
}

class _IncomeTab extends ConsumerWidget {
  const _IncomeTab({required this.currencySymbol});

  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsProvider);
    final l10n = context.l10n;

    return paymentsAsync.when(
      data: (payments) {
        if (payments.isEmpty)
          return Center(child: Text(l10n.t('noIncomeRecorded')));

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: payments.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final payment = payments[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: payment.type == 'refund'
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                child: Icon(
                  payment.type == 'refund' ? Icons.remove : Icons.add,
                  color: payment.type == 'refund' ? Colors.red : Colors.green,
                ),
              ),
              title:
                  Text('${payment.amount.toStringAsFixed(2)} $currencySymbol'),
              subtitle: Text(
                  '${_paymentMethodLabel(l10n, payment.method)} - ${DateFormat.yMMMd(l10n.locale.languageCode).format(payment.date)}'),
              trailing: Text(
                _paymentTypeLabel(l10n, payment.type).toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) =>
          Center(child: Text(l10n.tf('errorWithMessage', {'error': e}))),
    );
  }

  String _paymentMethodLabel(AppLocalizations l10n, String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return l10n.t('cash');
      case 'card':
      case 'credit_card':
        return l10n.t('card');
      case 'bank':
      case 'transfer':
        return l10n.t('bankTransfer');
      default:
        return method;
    }
  }

  String _paymentTypeLabel(AppLocalizations l10n, String type) {
    switch (type.toLowerCase()) {
      case 'refund':
        return l10n.t('refund');
      default:
        return l10n.t('income');
    }
  }
}

class _ExpensesTab extends ConsumerWidget {
  const _ExpensesTab({required this.currencySymbol});

  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);
    final l10n = context.l10n;

    return expensesAsync.when(
      data: (expenses) {
        if (expenses.isEmpty)
          return Center(child: Text(l10n.t('noExpensesRecorded')));

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: expenses.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.1),
                child: const Icon(Icons.money_off, color: Colors.red),
              ),
              title:
                  Text('${expense.amount.toStringAsFixed(2)} $currencySymbol'),
              subtitle: Text(
                '${expense.description} (${_categoryLabel(l10n, expense.category)})',
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
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) =>
          Center(child: Text(l10n.tf('errorWithMessage', {'error': e}))),
    );
  }

  String _categoryLabel(AppLocalizations l10n, String categoryCode) {
    switch (categoryCode.toLowerCase()) {
      case 'maintenance':
        return l10n.t('categoryMaintenance');
      case 'supplies':
        return l10n.t('categorySupplies');
      case 'utilities':
        return l10n.t('categoryUtilities');
      case 'salaries':
        return l10n.t('categorySalaries');
      default:
        return l10n.t('categoryOther');
    }
  }
}
