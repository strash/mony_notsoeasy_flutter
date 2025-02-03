import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/features/stats/components/bottom_sheet_calendar.dart";
import "package:mony_app/features/stats/page/view_model.dart";

final class OnDatePressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<StatsViewModel>();
    viewModel.dateController.visibleMonth =
        (viewModel.dateController.value ?? DateTime.now().startOfDay)
            .firstDayOfMonth();

    BottomSheetComponent.show<void>(
      context,
      builder: (context, bottom) {
        return StatsBottomSheetCalendarComponent(
          bottom: bottom,
          dateController: viewModel.dateController,
        );
      },
    );
  }
}
