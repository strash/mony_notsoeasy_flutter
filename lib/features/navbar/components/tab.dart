import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

extension on NavBarTabItem {
  String get icon {
    return switch (this) {
      NavBarTabItem.feed => Assets.icons.listBulletBelowRectangle,
      NavBarTabItem.settings => Assets.icons.gearshapeFill,
    };
  }
}

class NavBarTabComponent extends StatelessWidget {
  final int index;
  final double height;

  const NavBarTabComponent({
    super.key,
    required this.index,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NavBarViewModel>();
    final onTabChanged = viewModel<OnTabChangeRequested>();
    final tab = NavBarTabItem.from(index);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabChanged(context, tab),
      child: SizedBox.fromSize(
        size: Size.fromHeight(height),
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short4,
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
                width: 32.r,
                height: 32.r,
                colorFilter: ColorFilter.mode(
                  color ?? theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
