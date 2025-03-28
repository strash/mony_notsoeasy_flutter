import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/view.dart";
import "package:mony_app/features/navbar/page/view_model.dart";
import "package:mony_app/features/navbar/use_case/on_add_transaction_pressed.dart";
import "package:mony_app/gen/assets.gen.dart";

class NavBarButtonPlusComponent extends StatelessWidget {
  const NavBarButtonPlusComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.viewModel<NavBarViewModel>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => viewModel<OnAddTransactionPressed>()(context),
      child: SizedBox(
        width: NavBarView.kTabHeight * 1.618033,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: ColorScheme.of(context).primary,
            shape: Smooth.border(NavBarView.kRadius),
          ),
          child: Center(
            child: SvgPicture.asset(
              Assets.icons.plusBold,
              width: 32.0,
              height: 32.0,
              colorFilter: ColorFilter.mode(
                ColorScheme.of(context).surface,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
