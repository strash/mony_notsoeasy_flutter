import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/features/stats/page/view.dart";
import "package:mony_app/features/stats/use_case/use_case.dart";

final class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  ViewModelState<StatsPage> createState() => StatsViewModel();
}

final class StatsViewModel extends ViewModelState<StatsPage> {
  EChartTemporalView activeTemporalView = EChartTemporalView.defaultValue;

  List<AccountModel> accounts = [];
  AccountModel? activeAccount;

  ETransactionType activeTransactionType = ETransactionType.defaultValue;

  DateTime activeYear = DateTime.now().startOfDay;
  DateTime activeMonth = DateTime.now().startOfDay;
  DateTime activeWeek = DateTime.now().startOfDay;

  List<TransactionModel> transactions = [];

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      OnInit().call(context, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<StatsViewModel>(
      viewModel: this,
      child: const StatsView(),
    );
  }
}
