import "package:flutter/material.dart";
import "package:mony_app/common/extensions/figma_squircle.dart";

class BottomSheetHandleComponent extends StatelessWidget {
  static const double height = 20.0;

  const BottomSheetHandleComponent();

  @override
  Widget build(BuildContext context) {
    const verticalPadding = 8.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: verticalPadding,
      ),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(height - verticalPadding * 2.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 46.0,
            height: 4.0,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: ColorScheme.of(
                  context,
                ).onSurfaceVariant.withValues(alpha: 0.5),
                shape: Smooth.border(2.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
