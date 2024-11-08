import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/new_transaction/page/page.dart";

final class OnRemoveTagPressed extends UseCase<void, NewTransactionTag> {
  @override
  void call(BuildContext context, [NewTransactionTag? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<NewTransactionViewModel>();
    viewModel.setProtectedState(() {
      viewModel.attachedTags =
          List<NewTransactionTag>.from(viewModel.attachedTags)..remove(value);
    });
  }
}
