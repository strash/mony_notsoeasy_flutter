import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class TransactionTimeComponent extends StatelessWidget {
  final DateTime date;
  final bool showFullDate;

  const TransactionTimeComponent({
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

    return NumericText(
      formatter.format(date),
      maxLines: 1,
      style: GoogleFonts.golosText(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: 1.4,
        decoration: TextDecoration.none,
        color: ColorScheme.of(context).onSurfaceVariant,
        textStyle: TextTheme.of(context).bodyMedium,
      ),
    );
  }
}
