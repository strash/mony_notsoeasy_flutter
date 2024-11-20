import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedAddAccountComponent extends StatelessWidget {
  final VoidCallback onTap;

  const FeedAddAccountComponent({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top,
      right: 10.w,
      child: SizedBox.square(
        dimension: 50.r,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: SizedBox.square(
              dimension: 30.h,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: kTranslucentPanelBlurSigma,
                    sigmaY: kTranslucentPanelBlurSigma,
                  ),
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainer.withOpacity(.5),
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.icons.plusSemibold,
                        width: 20.r,
                        height: 20.r,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
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
