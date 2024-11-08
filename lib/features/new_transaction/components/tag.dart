import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";

class NewTransactionTagComponent extends StatelessWidget {
  final WidgetBuilder builder;

  const NewTransactionTagComponent({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surfaceContainer,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 12.r, cornerSmoothing: 1.0),
          ),
        ),
      ),
      child: DefaultTextStyle(
        style: GoogleFonts.golosText(
          fontSize: 15.sp,
          height: 1.0,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
        child: builder(context),
      ),
    );
  }
}
