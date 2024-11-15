import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class FeedAccountAmountComponent extends StatelessWidget {
  final String amount;
  final String code;

  const FeedAccountAmountComponent({
    super.key,
    required this.amount,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              amount,
              textAlign: TextAlign.start,
              style: GoogleFonts.golosText(
                fontSize: 40.sp,
                height: 1.1,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3.w, top: 8.h),
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: theme.colorScheme.tertiaryContainer,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 5.r,
                    cornerSmoothing: 1.0,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 3.h),
              child: Text(
                code,
                style: GoogleFonts.golosText(
                  fontSize: 10.sp,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
