import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/stats/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, StatsViewModel> {
  @override
  Future<void> call(BuildContext context, [StatsViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final transactionService = context.service<DomainTransactionService>();
    final accountService = context.service<DomainAccountService>();

    final (from, to) = viewModel.exclusiveDateRange;

    final accounts = await accountService.getAll();
    if (accounts.isEmpty) return;

    final balance = await accountService.getBalanceForDateRange(
      id: accounts.first.id,
      from: from,
      to: to,
    );

    final transactions = await transactionService.getRange(
      from: from,
      to: to,
      accountId: accounts.first.id,
      transactionType: viewModel.activeTransactionType,
    );

    viewModel.setProtectedState(() {
      viewModel.accounts = accounts;
      viewModel.accountController.value = accounts.first;
      viewModel.balance = balance;
      viewModel.transactions = transactions;
    });
  }
}
