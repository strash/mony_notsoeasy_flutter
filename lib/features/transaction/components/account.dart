import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/gen/assets.gen.dart";

class TransactionAccountComponent extends StatelessWidget {
  final AccountModel account;

  const TransactionAccountComponent({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final color =
        ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> account
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                account.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.golosText(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),

            // -> icon
            Padding(
              padding: EdgeInsets.only(left: 2.w, top: 1.h),
              child: SvgPicture.asset(
                Assets.icons.chevronForward,
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
          ],
        ),
        Text(
          account.type.description,
          style: GoogleFonts.golosText(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
