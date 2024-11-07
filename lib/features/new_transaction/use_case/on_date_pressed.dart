import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/new_transaction/components/bottom_sheet_calendar.dart";
import "package:mony_app/features/new_transaction/page/page.dart";

final class OnDatePressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<NewTransactionViewModel>();
    viewModel.dateController.visibleMonth =
        (viewModel.dateController.value ?? DateTime.now()).firstDayOfMonth();

    BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        return NewTransactionBottomSheetCalendarComponent(
          bottom: bottom,
          dateController: viewModel.dateController,
          timeController: viewModel.timeController,
        );
      },
    );
  }
}
