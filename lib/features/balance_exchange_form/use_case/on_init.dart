import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, BalanceExchangeFormViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    BalanceExchangeFormViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final accountService = context.service<DomainAccountService>();
    final accounts = await accountService.getAll();
    final balances = await accountService.getBalances();

    viewModel.setProtectedState(() {
      viewModel.accounts = accounts
          .where((e) => e.id != viewModel.activeAccount.id)
          .toList(growable: false);
      viewModel.balances = balances;
      viewModel.accountController.value = viewModel.accounts.firstOrNull;
    });
  }
}
