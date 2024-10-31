import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:sealed_currencies/sealed_currencies.dart";

class FeedSectionComponent extends StatelessWidget {
  final (DateTime, double) value;
  final FiatCurrency currency;

  const FeedSectionComponent({
    super.key,
    required this.value,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateFormatter = DateFormat(
      now.year != value.$1.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
    );
    final date = dateFormatter.format(value.$1);
    String sum = currency.format(value.$2);
    if (!value.$2.isNegative) sum = "+$sum";

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 35.h, 20.w, 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // -> date
          Text(
            date,
            style: GoogleFonts.golosText(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          // -> sum
          Text(
            sum,
            style: GoogleFonts.golosText(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
