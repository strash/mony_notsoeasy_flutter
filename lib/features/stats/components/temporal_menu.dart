import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/on_temporal_button_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";

class StatsTemporalViewMenuComponent extends StatelessWidget {
  const StatsTemporalViewMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currContext = context;

    final viewModel = context.viewModel<StatsViewModel>();
    final onTemporalButtonPressed = viewModel<OnTemporalButtonPressed>();

    return ContextMenuComponent(
      showBackground: false,
      blurBackground: false,
      buttonBuilder: (context) {
        return SizedBox.square(
          dimension: AppBarComponent.height,
          child: Center(
            child: SvgPicture.asset(
              viewModel.activeTemporalView.icon,
              width: 28.0,
              height: 28.0,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
      itemsBuilder: (context, dismiss) {
        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemCount: EChartTemporalView.values.length,
          itemBuilder: (context, index) {
            final item = EChartTemporalView.values.elementAt(index);

            return ContextMenuItemComponent(
              label: Text(item.description),
              icon: SvgPicture.asset(
                item.icon,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              isActive: viewModel.activeTemporalView == item,
              onTap: () {
                onTemporalButtonPressed(currContext, item);
                dismiss();
              },
            );
          },
        );
      },
    );
  }
}

extension on EChartTemporalView {
  String get description {
    return switch (this) {
      EChartTemporalView.year => "За год",
      EChartTemporalView.month => "За месяц",
      EChartTemporalView.week => "За неделю",
    };
  }

  String get icon {
    return switch (this) {
      EChartTemporalView.year => Assets.icons.ySquare,
      EChartTemporalView.month => Assets.icons.mSquare,
      EChartTemporalView.week => Assets.icons.wSquare,
    };
  }
}
