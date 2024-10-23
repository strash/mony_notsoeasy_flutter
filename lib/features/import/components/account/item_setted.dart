import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/domain/domain.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class AccountSettedButtonComponent extends StatelessWidget {
  final AccountVO account;

  const AccountSettedButtonComponent({required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currency = FiatCurrency.fromCode(account.currencyCode);
    final formatter = NumberFormat.compact();

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 20.w, 12.h),
      child: Row(
        children: [
          // -> color
          SizedBox(
            width: 8.w,
            height: 42.h,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: account.color,
                shape: SmoothRectangleBorder(
                  side: BorderSide(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                  ),
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(
                      cornerRadius: 4.r,
                      cornerSmoothing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -> title
                Text(
                  account.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                // -> account type
                Text(
                  account.type.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 12.sp,
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
