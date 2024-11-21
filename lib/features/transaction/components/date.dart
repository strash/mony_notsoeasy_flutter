import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class TransactionDateComponent extends StatelessWidget {
  final DateTime date;

  const TransactionDateComponent({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dateFormatter = DateFormat(
      now.year != date.year
          ? "EEE, dd MMMM yyyy, HH:mm"
          : "EEE, dd MMMM, HH:mm",
    );
    final formattedDate = dateFormatter.format(date);

    return Center(
      child: Text(
        formattedDate,
        textAlign: TextAlign.center,
        style: GoogleFonts.golosText(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
