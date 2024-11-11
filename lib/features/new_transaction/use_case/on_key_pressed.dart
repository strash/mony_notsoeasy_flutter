import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/new_transaction/components/keyboard_button_type.dart";

final class OnKeyPressed extends UseCase<void, ButtonType> {
  @override
  void call(BuildContext context, [ButtonType? button]) {
    if (button == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<NewTransactionViewModel>();

    final amount = viewModel.amountNotifier.value;
    switch (button) {
      case ButtonTypeSymbol():
        if (amount == "0" && button.value != ".") {
          viewModel.amountNotifier.value = button.value;
        } else {
          viewModel.amountNotifier.value = amount + button.value;
        }
      case ButtonTypeAction():
        print(amount);
    }
  }
}
