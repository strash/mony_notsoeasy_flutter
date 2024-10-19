import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/color_picker/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/start_account_create/page/view_model.dart";
import "package:provider/provider.dart";

final class OnCreateAccountPressed extends UseCase<Future<void>, dynamic> {
  AccountValueObject _value(BuildContext context) {
    final viewModel = context.viewModel<StartAccountCreateViewModel>();
    final balance =
        viewModel.balanceController.text.trim().replaceAll(",", ".");
    return AccountValueObject.create(
      title: viewModel.titleController.text.trim(),
      color: viewModel.colorController.value ?? Palette().randomColor,
      type: viewModel.typeController.value ?? EAccountType.defaultValue,
      currencyCode: viewModel.currencyController.value?.code ?? "USD",
      balance: double.tryParse(balance) ?? 0.0,
    );
  }

  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final accountService = context.read<AccountService>();
    final eventService = context.viewModel<AppEventService>();
    final account = await accountService.create(_value(context));
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      eventService.notify(
        EventAccountCreated(
          sender: StartAccountCreateViewModel,
          account: account,
        ),
      );
    }
  }
}
