import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class TransactionNoteComponent extends StatelessWidget {
  final String note;

  const TransactionNoteComponent({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // -> title
        Text(
          "Заметка",
          style: GoogleFonts.golosText(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        // ignore: prefer_const_constructors
        SizedBox(height: 10.0),

        // -> the note
        Text(
          note,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
