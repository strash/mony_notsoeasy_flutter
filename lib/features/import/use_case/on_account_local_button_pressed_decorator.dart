import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/use_case/on_account_button_pressed.dart";

final class OnAccountLocalButtonPressedDecorator
    extends UseCase<Future<void>, AccountVO?> {
  @override
  Future<void> call(BuildContext context, [AccountVO? value]) async {
    final viewModel = context.viewModel<ImportViewModel>();
    final onAccountPressed = viewModel<OnAccountButtonPressed>();
    final result = await onAccountPressed(context, value);
    if (result != null) {
      viewModel.setProtectedState(() {
        viewModel.singleAccount = result;
      });
    }
  }
}
