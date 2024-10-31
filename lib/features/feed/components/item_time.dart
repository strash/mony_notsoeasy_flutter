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

  double get margin => 6.w;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.Hm();

    return Padding(
      padding: EdgeInsets.only(right: margin),
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
