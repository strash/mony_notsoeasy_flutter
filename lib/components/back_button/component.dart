import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/gen/assets.gen.dart";

class BackButtonComponent extends StatelessWidget {
  const BackButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: navigator.maybePop<void>,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: SvgPicture.asset(
            width: 28.r,
            height: 28.r,
            Assets.icons.chevronBackward,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
