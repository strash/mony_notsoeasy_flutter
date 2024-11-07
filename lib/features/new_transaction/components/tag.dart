import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/new_transaction/page/view_model.dart";
import "package:mony_app/gen/assets.gen.dart";

class NewTransactionTagComponent extends StatelessWidget {
  final NewTransactionTag tag;

  const NewTransactionTagComponent({
    super.key,
    required this.tag,
  });

  String get _title {
    return switch (tag) {
      final NewTransactionTagVO odj => odj.vo.title,
      final NewTransactionTagModel obj => obj.model.title,
    };
  }

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
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Row(
          children: [
            // -> title
            Text(
              _title,
              style: GoogleFonts.golosText(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 3.w),

            // -> button remove
            SvgPicture.asset(
              Assets.icons.xmarkSemibold,
              width: 16.r,
              height: 16.r,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
