import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/gen/assets.gen.dart";

class FeedEmptyStateComponent extends StatelessWidget {
  const FeedEmptyStateComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.icons.sparkles,
          width: 150.r,
          height: 150.r,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.surfaceContainer,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          "Тут ничего нет. Найс!",
          style: GoogleFonts.golosText(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(.4),
          ),
        ),
      ],
    );
  }
}
