import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/domain/services/database/database.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:provider/provider.dart";

final class OnTemporalButtonPressed
    extends UseCase<Future<void>, EChartTemporalView> {
  @override
  Future<void> call(BuildContext context, [EChartTemporalView? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<StatsViewModel>();
    if (viewModel.accountController.value == null ||
        viewModel.activeTemporalView == value) {
      return;
    }
    final transactionService = context.read<DomainTransactionService>();
    final accountService = context.read<DomainAccountService>();

    viewModel.activeTemporalView = value;
    final (from, to) = viewModel.exclusiveDateRange;

    final balance = await accountService.getBalanceForDateRange(
      id: viewModel.accountController.value!.id,
      from: from,
      to: to,
    );
    final transactions = await transactionService.getRange(
      from: from,
      to: to,
      accountId: viewModel.accountController.value!.id,
      transactionType: viewModel.activeTransactionType,
    );

    viewModel.setProtectedState(() {
      viewModel.activeAccountBalance = balance;
      viewModel.transactions = transactions;
    });
  }
}
