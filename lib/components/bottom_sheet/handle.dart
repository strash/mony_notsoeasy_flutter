import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class BottomSheetHandleComponent extends StatelessWidget {
  static final double height = 20.h;

  const BottomSheetHandleComponent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verticalPadding = 8.h;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.w,
        vertical: verticalPadding,
      ),
      child: SizedBox.fromSize(
        size: Size.fromHeight(height - verticalPadding * 2.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 46.w,
            height: 4.h,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 2.r, cornerSmoothing: 1.0),
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
