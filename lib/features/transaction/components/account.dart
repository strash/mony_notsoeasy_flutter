import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/domain/models/account.dart";

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
    final accountColor =
        ex?.from(account.colorName).color ?? theme.colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> account
        Flexible(
          child: Text(
            account.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.golosText(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: accountColor,
            ),
          ),
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
