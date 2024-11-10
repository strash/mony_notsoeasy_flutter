import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/new_transaction/components/components.dart";

final class OnNotePressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<NewTransactionViewModel>();

    BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        return NewTransactionBottomSheetNoteComponent(
          inputController: viewModel.noteInput,
          keyboardHeight: bottom,
        );
      },
    );
  }
}
