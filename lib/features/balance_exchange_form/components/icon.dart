import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/gen/assets.gen.dart";

class BalanceExchangeFormIconComponent extends StatelessWidget {
  const BalanceExchangeFormIconComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SvgPicture.asset(
      Assets.icons.arrowDownCircleDotted,
      width: 36.0,
      height: 36.0,
      colorFilter: ColorFilter.mode(
        theme.colorScheme.primaryContainer,
        BlendMode.srcIn,
      ),
    );
  }
}
