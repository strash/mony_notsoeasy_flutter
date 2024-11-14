import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/gen/assets.gen.dart";

class CloseButtonComponent extends StatelessWidget {
  const CloseButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: navigator.maybePop<void>,
      child: SizedBox.square(
        dimension: 50.r,
        child: Center(
          child: SvgPicture.asset(
            Assets.icons.xmark,
            width: 28.r,
            height: 28.r,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
