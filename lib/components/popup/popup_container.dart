import "dart:ui";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/common/constants.dart";

class PopupContainerComoponent extends StatelessWidget {
  final WidgetBuilder builder;

  const PopupContainerComoponent({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.all(
          SmoothRadius(cornerRadius: 20.0, cornerSmoothing: 0.6),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: kTranslucentPanelBlurSigma,
            sigmaY: kTranslucentPanelBlurSigma,
          ),
          child: ColoredBox(
            color: ColorScheme.of(
              context,
            ).surfaceContainer.withValues(alpha: kTranslucentPanelOpacity),
            child: builder(context),
          ),
        ),
      ),
    );
  }
}
