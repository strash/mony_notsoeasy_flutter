import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/gen/assets.gen.dart";

class AccountUnsettedItemComponent extends StatelessWidget {
  final String? title;

  const AccountUnsettedItemComponent({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = this.title;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -> title
          Flexible(
            child: Text(
              (title != null && title.isNotEmpty) ? title : "Счет",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.golosText(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // -> icon edit
          SvgPicture.asset(
            Assets.icons.plus,
            width: 24.r,
            height: 24.r,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
