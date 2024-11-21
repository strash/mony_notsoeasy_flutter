import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class FeedItemTimeComponent extends StatelessWidget {
  final DateTime date;

  const FeedItemTimeComponent({
    super.key,
    required this.date,
  });

  double get margin => 14.0;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat("HH:mm");

    return Padding(
      padding: EdgeInsets.only(right: margin, bottom: 2.0),
      child: Text(
        formatter.format(date),
        maxLines: 1,
        style: GoogleFonts.golosText(
          fontSize: 16.0,
          height: .0,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
