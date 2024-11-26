import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/popup/button.dart";
import "package:mony_app/components/popup/popup_container.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedAddButtonComponent extends StatelessWidget {
  const FeedAddButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top,
      right: 8.0,
      child: PopupButtonComponent(
        builder: (context, isOpened, activate) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isOpened ? null : activate,
            child: Opacity(
              opacity: isOpened ? .0 : 1.0,
              child: const _Proxy(),
            ),
          );
        },
        proxyBuilder: (context, anim, rect, dismiss) => const _Proxy(),
        popupBuilder: (context, anim, rect, dismiss) {
          return Positioned.fromRect(
            rect: rect,
            child: Transform.scale(
              scale: anim.remap(.0, 1.0, .5, 1.0),
              child: Opacity(
                opacity: anim,
                child: PopupContainerComoponent(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: dismiss,
                            child: const Text("One"),
                          ),
                          const Text("Two"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Proxy extends StatelessWidget {
  const _Proxy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.square(
      dimension: AppBarComponent.height,
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
    );
  }
}
