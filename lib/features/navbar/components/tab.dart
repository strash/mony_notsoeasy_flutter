import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/app/view_model/view_model.dart";
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

  const NavBarTabComponent({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ViewModel.of<NavBarViewModel>(context);
    final tab = NavBarTabItem.from(index);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => viewModel.tab = index,
      child: SizedBox.fromSize(
        size: const Size.fromHeight(70.0),
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short4,
          curve: Curves.easeInOutQuad,
          tween: ColorTween(
            begin: theme.colorScheme.onSurface,
            end: viewModel.tab == index
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
          builder: (context, color, child) {
            return Center(
              child: SvgPicture.asset(
                tab.icon,
                width: 34.0,
                height: 34.0,
                colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
              ),
            );
          },
        ),
      ),
    );
  }
}