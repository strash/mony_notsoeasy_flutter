import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";

final class OnTypeSwitched extends UseCase<void, ETransactionType> {
  @override
  void call(BuildContext context, [ETransactionType? type]) {
    if (type == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<NewTransactionViewModel>();

    viewModel.setProtectedState(() {
      viewModel.activeType = type;
    });
  }
}
