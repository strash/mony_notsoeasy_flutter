import "dart:ui";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class TimePopupComponent extends StatelessWidget {
  final VoidCallback onTapOutside;
  final Rect initialRect;

  const TimePopupComponent({
    super.key,
    required this.onTapOutside,
    required this.initialRect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapOutside,
      child: SizedBox.expand(
        child: RepaintBoundary(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Stack(
              children: [
                ColoredBox(
                  color: theme.colorScheme.surfaceDim.withOpacity(0.3),
                ),
                Positioned.fromRect(
                  rect: initialRect,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 12.r,
                            cornerSmoothing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 8.h,
                      ),
                      child: Text(
                        "10:25",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
