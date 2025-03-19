import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/view_model.dart";
import "package:mony_app/features/navbar/use_case/on_tab_change_requested.dart";
import "package:mony_app/gen/assets.gen.dart";

class NavBarTabComponent extends StatelessWidget {
  final int index;

  const NavBarTabComponent({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NavBarViewModel>();
    final tab = ENavBarTabItem.from(index);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => viewModel<OnTabChangeRequested>()(context, tab),
      child: TweenAnimationBuilder<Color?>(
        duration: Durations.short3,
        curve: Curves.easeInOutQuad,
        tween: ColorTween(
          begin: theme.colorScheme.onSurface,
          end:
              viewModel.currentTab == tab
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
        ),
        builder: (context, color, child) {
          return Center(
            child: SvgPicture.asset(
              tab.icon,
              width: 28.0,
              height: 28.0,
              colorFilter: ColorFilter.mode(
                color ?? theme.colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on ENavBarTabItem {
  String get icon {
    return switch (this) {
      ENavBarTabItem.feed => Assets.icons.walletPassFill,
      ENavBarTabItem.stats => Assets.icons.chartBarFill,
      ENavBarTabItem.settings => Assets.icons.gearshapeFill,
    };
  }
}
