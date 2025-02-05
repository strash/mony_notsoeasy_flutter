import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class FeedItemTimeComponent extends StatelessWidget {
  final DateTime date;
  final bool showFullDate;

  const FeedItemTimeComponent({
    super.key,
    required this.date,
    required this.showFullDate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context);
    final formatter = DateFormat(
      showFullDate
          ? (now.year != date.year ? "HH:mm, dd MMM yyyy" : "HH:mm, dd MMM")
          : "HH:mm",
      locale.languageCode,
    );

    return Text(
      formatter.format(date),
      maxLines: 1,
      style: GoogleFonts.golosText(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
