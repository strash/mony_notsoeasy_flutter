import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/domain/services/database/transaction.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:provider/provider.dart";

final class OnTemporalButtonPressed
    extends UseCase<Future<void>, EChartTemporalView> {
  @override
  Future<void> call(BuildContext context, [EChartTemporalView? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<StatsViewModel>();
    if (viewModel.activeAccount == null) return;
    final transactionService = context.read<DomainTransactionService>();

    viewModel.activeTemporalView = value;
    final (from, to) = viewModel.period;

    final transactions = await transactionService.getRange(
      from: from,
      to: to,
      accountId: viewModel.activeAccount!.id,
      transactionType: viewModel.activeTransactionType,
    );

    viewModel.setProtectedState(() {
      viewModel.transactions = transactions;
    });
  }
}
