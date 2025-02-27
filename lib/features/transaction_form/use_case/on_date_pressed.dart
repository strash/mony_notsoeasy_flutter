import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/transaction_form/components/bottom_sheet_calendar.dart";
import "package:mony_app/features/transaction_form/transaction_form.dart";

final class OnDatePressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [_]) {
    final viewModel = context.viewModel<TransactionFormViewModel>();
    viewModel.dateController.visibleMonth =
        (viewModel.dateController.value ?? DateTime.now()).firstDayOfMonth();

    BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        return TransactionFormBottomSheetCalendarComponent(
          bottom: bottom,
          dateController: viewModel.dateController,
          timeController: viewModel.timeController,
        );
      },
    );
  }
}
