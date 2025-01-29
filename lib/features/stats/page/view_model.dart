import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/components/select/select.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/stats/page/view.dart";
import "package:mony_app/features/stats/use_case/use_case.dart";
import "package:provider/provider.dart";

final class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  ViewModelState<StatsPage> createState() => StatsViewModel();
}

final class StatsViewModel extends ViewModelState<StatsPage> {
  bool isColorsVisible = true;

  List<AccountModel> accounts = [];

  ETransactionType activeTransactionType = ETransactionType.defaultValue;

  DateTime activeYear = DateTime.now().startOfDay;
  DateTime activeMonth = DateTime.now().startOfDay;
  DateTime activeWeek = DateTime.now().startOfDay;

  List<TransactionModel> transactions = [];

  EChartTemporalView activeTemporalView = EChartTemporalView.defaultValue;
  late final accountController = SelectController<AccountModel?>(null);

  (DateTime, DateTime) get period {
    final loc = MaterialLocalizations.of(context);
    final DateTime from;
    final DateTime to;
    switch (activeTemporalView) {
      case EChartTemporalView.year:
        final list = activeYear.monthsOfYear();
        from = list.first;
        to = list.last.offsetMonth(1);
      case EChartTemporalView.month:
        final list = activeMonth.daysOfMonth();
        from = list.first;
        to = list.last.add(const Duration(days: 1));
      case EChartTemporalView.week:
        final list = activeWeek.daysOfWeek(loc);
        from = list.first;
        to = list.last.add(const Duration(days: 1));
    }
    return (from, to);
  }

  void _onAccountSelected() {
    OnAccountSelected().call(context, this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      accountController.addListener(_onAccountSelected);

      final sharedPrefService = context.read<DomainSharedPreferencesService>();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      setProtectedState(() => isColorsVisible = colors);

      if (!mounted) return;
      await OnInit().call(context, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<StatsViewModel>(
      viewModel: this,
      useCases: [
        () => OnTemporalButtonPressed(),
      ],
      child: const StatsView(),
    );
  }
}
