import "package:flutter/widgets.dart" show BuildContext, DragStartDetails;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/features/transaction_form/page/view_model.dart";

final class OnHorizontalDragStarted extends UseCase<void, DragStartDetails> {
  @override
  void call(BuildContext context, [DragStartDetails? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<TransactionFormViewModel>();
    viewModel.dragStartPosition = value.globalPosition;
  }
}
