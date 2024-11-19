import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/transaction_form/components/components.dart";

final class OnNotePressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<TransactionFormViewModel>();

    BottomSheetComponent.show<void>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return TransactionFormBottomSheetNoteComponent(
          inputController: viewModel.noteInput,
          keyboardHeight: bottom,
        );
      },
    );
  }
}
