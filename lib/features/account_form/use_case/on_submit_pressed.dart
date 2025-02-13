import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnSumbitPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<AccountFormViewModel>();
    final navigator = Navigator.of(context);

    final cleanBalance = viewModel.balanceController.text.trim().replaceAll(
      ",",
      ".",
    );
    final colorName =
        viewModel.colorController.value?.name ?? EColorName.random().name;
    final type = viewModel.typeController.value ?? EAccountType.defaultValue;
    final currencyCode =
        viewModel.currencyController.value?.code ?? kDefaultCurrencyCode;

    double balance = double.tryParse(cleanBalance) ?? 0.0;

    if (viewModel.widget.account case AccountVariantModel(:final model)) {
      final service = context.read<DomainAccountService>();
      final accBalance = await service.getBalance(id: model.id);
      if (accBalance != null) {
        balance = (balance - accBalance.totalAmount).roundToFraction(2);
      }
    }

    final vo = AccountVO(
      title: viewModel.titleController.text.trim(),
      colorName: colorName,
      type: type,
      currencyCode: currencyCode,
      balance: balance,
    );

    navigator.pop<AccountVO>(vo);
  }
}
