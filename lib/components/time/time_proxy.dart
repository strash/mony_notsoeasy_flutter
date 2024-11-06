import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class TimeProxyComponent extends StatelessWidget {
  final String time;

  const TimeProxyComponent({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 90.w,
      height: 44.h,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: theme.colorScheme.surfaceContainer,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 14.r, cornerSmoothing: 1.0),
            ),
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: GoogleFonts.golosText(
              textStyle: theme.textTheme.bodyMedium,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
              color: theme.colorScheme.onSurface,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
