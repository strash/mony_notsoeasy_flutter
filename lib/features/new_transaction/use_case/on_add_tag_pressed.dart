import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_transaction/components/bottom_sheet_tags.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

final class OnAddTagPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<NewTransactionViewModel>();

    final result = await BottomSheetComponent.show<NewTransactionTag?>(
      context,
      builder: (context, bottom) {
        return NewTransactionBottomSheetTagsComponent(
          controller: viewModel.tagInput,
          keyboardHeight: bottom,
        );
      },
    );

    viewModel.tagInput.text = "";
    print(result);
  }
}
