import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
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
    final viewModel = context.viewModel<ImportViewModel>();
    final onBackwardPressed = viewModel<OnBackwardPressed>();
    final onForwardPressed = viewModel<OnForwardPressed>();
    final backEnabled = event is! ImportEventInitial &&
        event is! ImportEventLoadingCsv &&
        event is! ImportEventErrorLoadingCsv;
    final currentColumn = viewModel.currentColumn;
    final currentMappedColumn = viewModel.mappedColumns.lastOrNull;
    final forwardEnabled = event is ImportEventCsvLoaded ||
        (event is ImportEventMappingColumns ||
                event is ImportEventValidatingMappedColumns) &&
            currentColumn != null &&
            (currentColumn.isRequired &&
                    currentMappedColumn != null &&
                    currentMappedColumn.entryKey != null ||
                !currentColumn.isRequired);

    return Row(
      children: [
        // -> button back
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
          ),
          onPressed:
              backEnabled ? () => onBackwardPressed(context, event) : null,
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
            onPressed:
                forwardEnabled ? () => onForwardPressed(context, event) : null,
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
