import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/transaction_form/transaction_form.dart";

final class OnHorizontalDragEnded extends UseCase<void, DragEndDetails> {
  @override
  void call(BuildContext context, [DragEndDetails? details]) {
    if (details == null) throw ArgumentError.notNull();

    final viewSize = MediaQuery.sizeOf(context);
    if (details.velocity.pixelsPerSecond.dx.abs() > viewSize.width * .4) {
      final viewModel = context.viewModel<TransactionFormViewModel>();
      final value = viewModel.amountNotifier.value;
      if (value.length == 1) {
        viewModel.amountNotifier.value = "0";
      } else {
        viewModel.amountNotifier.value = value.substring(0, value.length - 1);
      }
    }
  }
}
