import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/view_model.dart";

final class OnSumbitAccountPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<AccountFormViewModel>();
    final balance =
        viewModel.balanceController.text.trim().replaceAll(",", ".");
    final vo = AccountVO(
      title: viewModel.titleController.text.trim(),
      colorName:
          viewModel.colorController.value?.name ?? EColorName.random().name,
      type: viewModel.typeController.value ?? EAccountType.defaultValue,
      currencyCode:
          viewModel.currencyController.value?.code ?? kDefaultCurrencyCode,
      balance: double.tryParse(balance) ?? 0.0,
    );
    Navigator.of(context).pop<AccountVO>(vo);
  }
}
