import "dart:ui";

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
    final viewModel = context.viewModel<NavBarViewModel>();
    final onAddTransactionPressed = viewModel<OnAddTransactionPressed>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onAddTransactionPressed(context),
      child: ClipSmoothRect(
        radius: SmoothBorderRadius.all(
          SmoothRadius(
            cornerRadius: NavBarView.kRadius,
            cornerSmoothing: 1.0,
          ),
        ),
        child: SizedBox(
          width: NavBarView.kTabHeight * 1.618033,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: NavBarView.kSigma,
              sigmaY: NavBarView.kSigma,
              tileMode: TileMode.repeated,
            ),
            child: ColoredBox(
              color: theme.colorScheme.primary.withOpacity(.7),
              child: Center(
                child: SvgPicture.asset(
                  Assets.icons.plus,
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
        ),
      ),
    );
  }
}
