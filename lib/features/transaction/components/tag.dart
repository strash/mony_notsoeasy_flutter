import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/domain/models/transaction_tag.dart";

class TransactionTagComponent extends StatelessWidget {
  final TransactionTagModel tag;

  const TransactionTagComponent({
    super.key,
    required this.tag,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Text(
          "#${tag.title}",
          style: GoogleFonts.golosText(
            fontSize: 16.sp,
            height: 1.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onTertiaryContainer,
          ),
        ),
      ),
    );
  }
}
