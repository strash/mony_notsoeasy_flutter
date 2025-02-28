import "package:flutter/widgets.dart" show BuildContext, Navigator;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/features/balance_exchange_form/page/view_model.dart";

final class OnSubmitPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<BalanceExchangeFormViewModel>();
    final navigator = Navigator.of(context);

    final leftAccount = viewModel.leftAccount;
    final rightAccount = viewModel.rightAccount;
    if (leftAccount == null || rightAccount == null) return;

    final amountTrim = viewModel.amountController.text.trim();
    final amount = (double.tryParse(amountTrim) ?? .0).abs().roundToFraction(2);
    final convertedTrim = viewModel.coefficientController.text.trim();
    final convertedAmount = (double.tryParse(
              viewModel.isSameCurrency ? amountTrim : convertedTrim,
            ) ??
            .0)
        .abs()
        .roundToFraction(2);

    final leftBalanceResult = leftAccount.balance - amount;
    final rightBalanceResult = rightAccount.balance + convertedAmount;

    navigator.pop<(AccountModel, AccountModel)>((
      leftAccount.copyWith(balance: leftBalanceResult),
      rightAccount.copyWith(balance: rightBalanceResult),
    ));
  }
}
