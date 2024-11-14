import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class AccountSettedButtonComponent extends StatelessWidget {
  final AccountVO account;

  const AccountSettedButtonComponent({required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final currency = FiatCurrency.fromCode(account.currencyCode);
    final formatter = NumberFormat.compact();
    final color = ex?.from(EColorName.from(account.colorName)).color ??
        theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> title
                Text(
                  account.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),

                // -> account type
                Text(
                  account.type.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w),

          // -> balance with currency
          Text(
            currency.addUnit(formatter.format(account.balance)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.golosText(
              fontSize: 16.sp,
              height: 1.0,
              fontWeight: FontWeight.w500,
              color: account.balance >= 0.0
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
