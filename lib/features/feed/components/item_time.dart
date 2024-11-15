import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class FeedItemTimeComponent extends StatelessWidget {
  final DateTime date;

  const FeedItemTimeComponent({
    super.key,
    required this.date,
  });

  double get margin => 10.w;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("HH:mm");

    return Padding(
      padding: EdgeInsets.only(right: margin, bottom: 2.h),
      child: Text(
        formatter.format(date),
        maxLines: 1,
        style: GoogleFonts.golosText(
          fontSize: 16.sp,
          height: .0,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
