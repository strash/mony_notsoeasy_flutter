import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/navbar/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class NavBarButtonPlusComponent extends StatelessWidget {
  const NavBarButtonPlusComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<NavbarViewModel>();
    final onAddTransactionPressed = viewModel<OnAddTransactionPressed>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onAddTransactionPressed(context),
      child: SizedBox(
        width: NavbarView.kTabHeight * 1.618033,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: theme.colorScheme.primary,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.all(
                SmoothRadius(
                  cornerRadius: NavbarView.kRadius,
                  cornerSmoothing: 1.0,
                ),
              ),
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.plusBold,
              width: 32.r,
              height: 32.r,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.surface,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
