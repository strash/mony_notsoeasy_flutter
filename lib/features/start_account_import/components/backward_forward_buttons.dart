import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/gen/assets.gen.dart";

class BackwardForwardButtonsComponent extends StatelessWidget {
  final ImportEvent? event;

  const BackwardForwardButtonsComponent({
    super.key,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ViewModel.of<StartAccountImportViewModel>(context);
    final backEnabled = event is! ImportEventInitial &&
        event is! ImportEventLoadingCsv &&
        event is! ImportEventErrorLoadingCsv;
    final forwardEnabled = event is ImportEventCsvLoaded ||
        event is ImportEventMapAccount ||
        event is ImportEventMapAmount &&
            viewModel.mappedCsvColumns.amount != null ||
        event is ImportEventMapExpenseType ||
        event is ImportEventMapDate &&
            viewModel.mappedCsvColumns.date != null ||
        event is ImportEventMapCategory &&
            viewModel.mappedCsvColumns.category != null ||
        event is ImportEventMapTag ||
        event is ImportEventMapNote;

    return Row(
      children: [
        // -> button back
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
          ),
          onPressed: backEnabled
              ? () => viewModel.onBackwardPressed(context, event)
              : null,
          child: IgnorePointer(
            child: SvgPicture.asset(
              Assets.icons.chevronBackward,
              width: 22.r,
              height: 22.r,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onTertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),

        // -> button next
        Expanded(
          child: FilledButton(
            onPressed: forwardEnabled
                ? () => viewModel.onForwardPressed(context, event)
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Дальше"),
                SizedBox(width: 8.w),
                SvgPicture.asset(
                  Assets.icons.chevronForward,
                  width: 22.r,
                  height: 22.r,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onTertiary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
