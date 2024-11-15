import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class TransactionFormTagComponent extends StatelessWidget {
  final WidgetBuilder builder;

  const TransactionFormTagComponent({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 12.r, cornerSmoothing: 1.0),
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.golosText(
          fontSize: 16.sp,
          height: 1.0,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onTertiaryContainer,
        ),
        child: builder(context),
      ),
    );
  }
}
