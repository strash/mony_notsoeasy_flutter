import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/database/vo/transaction_tag.dart";
import "package:mony_app/features/transaction_form/page/page.dart";

final class OnRemoveTagPressed extends UseCase<void, TransactionTagVO> {
  @override
  void call(BuildContext context, [TransactionTagVO? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<TransactionFormViewModel>();
    viewModel.setProtectedState(() {
      viewModel.attachedTags =
          List<TransactionTagVO>.from(viewModel.attachedTags)..remove(value);
    });
  }
}
