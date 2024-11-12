import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/features/feed/page/state.dart";
import "package:mony_app/features/feed/page/view_model.dart";

class FeedSectionComponent extends StatelessWidget {
  final FeedItemSection section;

  const FeedSectionComponent({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateFormatter = DateFormat(
      now.year != section.date.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
    );
    final date = dateFormatter.format(section.date);

    final sum = section.total.entries.map((e) {
      return NumberFormat.currency(
        name: e.key.name,
        symbol: e.key.symbol,
      ).format(e.value);
    }).join(", ");

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
          Flexible(
            child: Text(
              sum,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.golosText(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
