import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/color_picker/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_create/page/view_model.dart";

final class OnCreateAccountPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<AccountCreateViewModel>();
    final balance =
        viewModel.balanceController.text.trim().replaceAll(",", ".");
    final vo = AccountValueObject.create(
      title: viewModel.titleController.text.trim(),
      color: viewModel.colorController.value ?? Palette().randomColor,
      type: viewModel.typeController.value ?? EAccountType.defaultValue,
      currencyCode: viewModel.currencyController.value?.code ?? "RUB",
      balance: double.tryParse(balance) ?? 0.0,
    );
    Navigator.of(context).pop<AccountValueObject>(vo);
  }
}
