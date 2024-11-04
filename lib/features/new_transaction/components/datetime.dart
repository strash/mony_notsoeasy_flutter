import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/gen/assets.gen.dart";

class NewTransactionDatetimeComponent extends StatelessWidget {
  const NewTransactionDatetimeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat("d MMM yyyy").add_Hm();

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          side: BorderSide(color: theme.colorScheme.outline),
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 12.r, cornerSmoothing: 1.0),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 9.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -> date time
            Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 5.h),
              child: Text(
                formatter.format(DateTime.now()),
                style: GoogleFonts.golosText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(width: 6.w),

            // -> icon
            SvgPicture.asset(
              Assets.icons.calendar,
              width: 20.r,
              height: 20.r,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.tertiary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
