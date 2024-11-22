import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/components/appbar/component.dart";
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
      right: 8.0,
      child: SizedBox.square(
        dimension: AppBarComponent.height,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: SizedBox.square(
              dimension: 30.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
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
                        width: 20.0,
                        height: 20.0,
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
