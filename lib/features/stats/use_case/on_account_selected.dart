import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/services/database/database.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:provider/provider.dart";

final class OnAccountSelected extends UseCase<Future<void>, StatsViewModel> {
  @override
  Future<void> call(BuildContext context, [StatsViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();
    if (viewModel.accountController.value == null) return;

    final transactionService = context.read<DomainTransactionService>();
    final accountService = context.read<DomainAccountService>();

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
