// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for expense list (read-only)

@ProviderFor(expenseList)
const expenseListProvider = ExpenseListProvider._();

/// Provider for expense list (read-only)

final class ExpenseListProvider extends $FunctionalProvider<
        AsyncValue<List<ExpenseModel>>,
        List<ExpenseModel>,
        FutureOr<List<ExpenseModel>>>
    with
        $FutureModifier<List<ExpenseModel>>,
        $FutureProvider<List<ExpenseModel>> {
  /// Provider for expense list (read-only)
  const ExpenseListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseListHash();

  @$internal
  @override
  $FutureProviderElement<List<ExpenseModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExpenseModel>> create(Ref ref) {
    return expenseList(ref);
  }
}

String _$expenseListHash() => r'3ba248bf77b37393605fde1e04162ba100f7fc40';

/// Provider for expenses in a date range (for reports)

@ProviderFor(expensesInRange)
const expensesInRangeProvider = ExpensesInRangeFamily._();

/// Provider for expenses in a date range (for reports)

final class ExpensesInRangeProvider extends $FunctionalProvider<
        AsyncValue<List<ExpenseModel>>,
        List<ExpenseModel>,
        FutureOr<List<ExpenseModel>>>
    with
        $FutureModifier<List<ExpenseModel>>,
        $FutureProvider<List<ExpenseModel>> {
  /// Provider for expenses in a date range (for reports)
  const ExpensesInRangeProvider._(
      {required ExpensesInRangeFamily super.from,
      required (
        DateTime,
        DateTime,
      )
          super.argument})
      : super(
          retry: null,
          name: r'expensesInRangeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expensesInRangeHash();

  @override
  String toString() {
    return r'expensesInRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ExpenseModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExpenseModel>> create(Ref ref) {
    final argument = this.argument as (
      DateTime,
      DateTime,
    );
    return expensesInRange(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesInRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesInRangeHash() => r'586e1b570b218584fdc50af844aacbe83ff5bfa7';

/// Provider for expenses in a date range (for reports)

final class ExpensesInRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<ExpenseModel>>,
            (
              DateTime,
              DateTime,
            )> {
  const ExpensesInRangeFamily._()
      : super(
          retry: null,
          name: r'expensesInRangeProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for expenses in a date range (for reports)

  ExpensesInRangeProvider call(
    DateTime start,
    DateTime end,
  ) =>
      ExpensesInRangeProvider._(argument: (
        start,
        end,
      ), from: this);

  @override
  String toString() => r'expensesInRangeProvider';
}

/// Provider for expenses by category

@ProviderFor(expensesByCategory)
const expensesByCategoryProvider = ExpensesByCategoryFamily._();

/// Provider for expenses by category

final class ExpensesByCategoryProvider extends $FunctionalProvider<
        AsyncValue<List<ExpenseModel>>,
        List<ExpenseModel>,
        FutureOr<List<ExpenseModel>>>
    with
        $FutureModifier<List<ExpenseModel>>,
        $FutureProvider<List<ExpenseModel>> {
  /// Provider for expenses by category
  const ExpensesByCategoryProvider._(
      {required ExpensesByCategoryFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'expensesByCategoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expensesByCategoryHash();

  @override
  String toString() {
    return r'expensesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ExpenseModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ExpenseModel>> create(Ref ref) {
    final argument = this.argument as String;
    return expensesByCategory(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesByCategoryHash() =>
    r'ef72b71f844fc75506d98adaf7b04233429374e4';

/// Provider for expenses by category

final class ExpensesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ExpenseModel>>, String> {
  const ExpensesByCategoryFamily._()
      : super(
          retry: null,
          name: r'expensesByCategoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for expenses by category

  ExpensesByCategoryProvider call(
    String category,
  ) =>
      ExpensesByCategoryProvider._(argument: category, from: this);

  @override
  String toString() => r'expensesByCategoryProvider';
}

/// Provider for total expenses in a period

@ProviderFor(totalExpenses)
const totalExpensesProvider = TotalExpensesFamily._();

/// Provider for total expenses in a period

final class TotalExpensesProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Provider for total expenses in a period
  const TotalExpensesProvider._(
      {required TotalExpensesFamily super.from,
      required (
        DateTime,
        DateTime,
      )
          super.argument})
      : super(
          retry: null,
          name: r'totalExpensesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalExpensesHash();

  @override
  String toString() {
    return r'totalExpensesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as (
      DateTime,
      DateTime,
    );
    return totalExpenses(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TotalExpensesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalExpensesHash() => r'6e55bfcef65f4f1b680d88bebcc8b10f2e47711a';

/// Provider for total expenses in a period

final class TotalExpensesFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<double>,
            (
              DateTime,
              DateTime,
            )> {
  const TotalExpensesFamily._()
      : super(
          retry: null,
          name: r'totalExpensesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for total expenses in a period

  TotalExpensesProvider call(
    DateTime start,
    DateTime end,
  ) =>
      TotalExpensesProvider._(argument: (
        start,
        end,
      ), from: this);

  @override
  String toString() => r'totalExpensesProvider';
}

/// Provider for total income in a period

@ProviderFor(totalIncome)
const totalIncomeProvider = TotalIncomeFamily._();

/// Provider for total income in a period

final class TotalIncomeProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Provider for total income in a period
  const TotalIncomeProvider._(
      {required TotalIncomeFamily super.from,
      required (
        DateTime,
        DateTime,
      )
          super.argument})
      : super(
          retry: null,
          name: r'totalIncomeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalIncomeHash();

  @override
  String toString() {
    return r'totalIncomeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as (
      DateTime,
      DateTime,
    );
    return totalIncome(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TotalIncomeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalIncomeHash() => r'bd9899935359d0c9759d545982b892388e936323';

/// Provider for total income in a period

final class TotalIncomeFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<double>,
            (
              DateTime,
              DateTime,
            )> {
  const TotalIncomeFamily._()
      : super(
          retry: null,
          name: r'totalIncomeProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for total income in a period

  TotalIncomeProvider call(
    DateTime start,
    DateTime end,
  ) =>
      TotalIncomeProvider._(argument: (
        start,
        end,
      ), from: this);

  @override
  String toString() => r'totalIncomeProvider';
}

/// Expense controller for mutations

@ProviderFor(ExpenseController)
const expenseControllerProvider = ExpenseControllerProvider._();

/// Expense controller for mutations
final class ExpenseControllerProvider
    extends $AsyncNotifierProvider<ExpenseController, void> {
  /// Expense controller for mutations
  const ExpenseControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseControllerHash();

  @$internal
  @override
  ExpenseController create() => ExpenseController();
}

String _$expenseControllerHash() => r'96fbb93760b2daf5f7f21f8088f7024ddacf8976';

/// Expense controller for mutations

abstract class _$ExpenseController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, null);
  }
}
