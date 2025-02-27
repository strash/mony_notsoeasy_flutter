import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnSubmitPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final leftAccount = viewModel.leftAccount;
    final rightAccount = viewModel.rightAccount;
    if (leftAccount == null || rightAccount == null) return;
    final accountService = context.read<DomainAccountService>();

    final amount =
        double.tryParse(viewModel.amountController.text.trim()) ?? .0;
    final coefficient =
        double.tryParse(viewModel.coefficientController.text.trim()) ?? 1.0;
    final result = (amount * coefficient).abs().roundToFraction(2);
    final leftBalance = switch (viewModel.action) {
      EBalanceExchangeMenuItem.receive => leftAccount.balance + result,
      EBalanceExchangeMenuItem.send => leftAccount.balance - result,
    };
    final rightBalance = switch (viewModel.action) {
      EBalanceExchangeMenuItem.receive => rightAccount.balance - result,
      EBalanceExchangeMenuItem.send => rightAccount.balance + result,
    };
  }
}
