import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/components/appbar/component.dart";
import "package:mony_app/components/popup/button.dart";
import "package:mony_app/components/popup/popup.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedAddButtonComponent extends StatelessWidget {
  const FeedAddButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.viewPaddingOf(context).top,
      right: 8.0,
      child: PopupButtonComponent(
        builder: (context, isOpened) {
          return Opacity(
            opacity: isOpened ? .0 : 1.0,
            child: const _Proxy(),
          );
        },
        proxyBuilder: (context) => const _Proxy(),
        popupBuilder: (context, anim, rect, dismiss) {
          return Positioned.fromRect(
            rect: rect,
            child: Opacity(
              opacity: anim,
              child: PopupComponent(
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
