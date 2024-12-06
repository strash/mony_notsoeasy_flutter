import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/services/database/vo/transaction_tag.dart";
import "package:mony_app/features/transaction_form/transaction_form.dart";

final class OnRemoveTagPressed extends UseCase<void, TransactionTagVariant> {
  @override
  void call(BuildContext context, [TransactionTagVariant? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<TransactionFormViewModel>();
    viewModel.setProtectedState(() {
      viewModel.attachedTags =
          List<TransactionTagVariant>.from(viewModel.attachedTags)
            ..remove(value);
    });
  }
}
