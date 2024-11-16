import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/gen/assets.gen.dart";

class NavigationButtonsComponent extends StatelessWidget {
  final ImportEvent? event;

  const NavigationButtonsComponent({
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
        event is! ImportEventErrorLoadingCsv &&
        event is! ImportEventValidatingMappedColumns;
    final forwardEnabled = event is ImportEventMapTransactionType &&
            viewModel.mappedTransactionTypeExpense != null &&
            viewModel.mappedTransactionTypeIncome != null ||
        event is ImportEventMapCategories &&
            viewModel.mappedCategories.entries.every((e) {
              return e.value
                  .every((c) => c.vo != null || c.linkedModel != null);
            });

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
            onPressed: viewModel.currentStep.isReady()
                ? () => onForwardPressed(context, event)
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
