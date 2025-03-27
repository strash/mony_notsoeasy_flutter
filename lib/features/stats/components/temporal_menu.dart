import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/on_temporal_button_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class StatsTemporalViewMenuComponent extends StatelessWidget {
  const StatsTemporalViewMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final currContext = context;
    final viewModel = context.viewModel<StatsViewModel>();

    // if it's needs to be disabled
    const isActive = true;

    return ContextMenuComponent(
      showBackground: false,
      blurBackground: false,
      buttonBuilder: (context, isOpened, activate) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isOpened || !isActive ? null : activate,
          child: AnimatedOpacity(
            duration: Durations.short4,
            // ignore: dead_code
            opacity: isActive ? 1.0 : .3,
            child: Opacity(
              opacity: isOpened ? .0 : 1.0,
              child: _Button(viewModel.activeTemporalView.icon),
            ),
          ),
        );
      },
      buttonProxyBuilder: (context, anim, status, dismiss) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: dismiss,
          child: _Button(viewModel.activeTemporalView.icon),
        );
      },
      popupBuilder: (context, anim, status, dismiss) {
        return SeparatedComponent.builder(
          mainAxisSize: MainAxisSize.min,
          separatorBuilder: (context, index) {
            return const ContextMenuSeparatorComponent(isBig: false);
          },
          itemCount: EChartTemporalView.values.length,
          itemBuilder: (context, index) {
            final item = EChartTemporalView.values.elementAt(index);

            return ContextMenuItemComponent(
              label: Text(context.t.components.charts.temporal(context: item)),
              icon: SvgPicture.asset(
                item.icon,
                colorFilter: ColorFilter.mode(
                  ColorScheme.of(context).onSurface,
                  BlendMode.srcIn,
                ),
              ),
              isActive: viewModel.activeTemporalView == item,
              onTap: () {
                viewModel<OnTemporalButtonPressed>()(currContext, item);
                dismiss();
              },
            );
          },
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  final String icon;

  const _Button(this.icon);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppBarComponent.height,
      child: Center(
        child: SvgPicture.asset(
          icon,
          width: 28.0,
          height: 28.0,
          colorFilter: ColorFilter.mode(
            ColorScheme.of(context).primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

extension on EChartTemporalView {
  String get icon {
    return switch (this) {
      EChartTemporalView.year => Assets.icons.ySquare,
      EChartTemporalView.month => Assets.icons.mSquare,
      EChartTemporalView.week => Assets.icons.wSquare,
    };
  }
}
