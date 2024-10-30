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

  TextStyle _getStyle(BuildContext context) {
    return GoogleFonts.golosText(
      fontSize: 14.sp,
      height: .0,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat.Hm();

    return Padding(
      padding: EdgeInsets.only(right: margin),
      child: Text(
        timeFormatter.format(date),
        maxLines: 1,
        style: _getStyle(context),
      ),
    );
  }
}
