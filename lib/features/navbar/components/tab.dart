import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

extension on NavbarTabItem {
  String get icon {
    return switch (this) {
      NavbarTabItem.feed => Assets.icons.walletPassFill,
      NavbarTabItem.stats => Assets.icons.chartBarFill,
      NavbarTabItem.settings => Assets.icons.gearshapeFill,
    };
  }
}

class NavBarTabComponent extends StatelessWidget {
  final int index;

  const NavBarTabComponent({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NavbarViewModel>();
    final onTabChanged = viewModel<OnTabChangeRequested>();
    final tab = NavbarTabItem.from(index);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabChanged(context, tab),
      child: TweenAnimationBuilder<Color?>(
        duration: Durations.short3,
        curve: Curves.easeInOutQuad,
        tween: ColorTween(
          begin: theme.colorScheme.onSurface,
          end: viewModel.currentTab == tab
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurfaceVariant,
        ),
        builder: (context, color, child) {
          return Center(
            child: SvgPicture.asset(
              tab.icon,
              width: 28.r,
              height: 28.r,
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
