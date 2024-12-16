import "dart:ui";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/common/constants.dart";

class PopupContainerComoponent extends StatelessWidget {
  final WidgetBuilder builder;

  const PopupContainerComoponent({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.all(
          SmoothRadius(
            cornerRadius: 20.0,
            cornerSmoothing: 1.0,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: kTranslucentPanelBlurSigma,
            sigmaY: kTranslucentPanelBlurSigma,
          ),
          child: ColoredBox(
            color: theme.colorScheme.surfaceContainer
                .withValues(alpha: kTranslucentPanelOpacity),
            child: builder(context),
          ),
        ),
      ),
    );
  }
}
