import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class TransactionDateComponent extends StatelessWidget {
  final DateTime date;

  const TransactionDateComponent({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context);
    final dateFormatter = DateFormat(
      now.year != date.year
          ? "EEE, dd MMMM yyyy, HH:mm"
          : "EEE, dd MMMM, HH:mm",
      locale.languageCode,
    );

    return Center(
      child: Text(
        dateFormatter.format(date),
        textAlign: TextAlign.center,
        style: GoogleFonts.golosText(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: ColorScheme.of(context).onSurfaceVariant,
        ),
      ),
    );
  }
}
