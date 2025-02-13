import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class NavigationButtonsComponent extends StatelessWidget {
  final ImportEvent? event;

  const NavigationButtonsComponent({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final onBackwardPressed = viewModel<OnBackwardPressed>();
    final onForwardPressed = viewModel<OnForwardPressed>();
    final backEnabled =
        event is! ImportEventInitial &&
        event is! ImportEventLoadingCsv &&
        event is! ImportEventErrorLoadingCsv &&
        event is! ImportEventValidatingMappedColumns;

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
              width: 22.0,
              height: 22.0,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onTertiary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),

        // -> button next
        Expanded(
          child: FilledButton(
            onPressed:
                viewModel.currentStep.isReady()
                    ? () => onForwardPressed(context, event)
                    : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Дальше"),
                const SizedBox(width: 8.0),
                SvgPicture.asset(
                  Assets.icons.chevronForward,
                  width: 22.0,
                  height: 22.0,
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
