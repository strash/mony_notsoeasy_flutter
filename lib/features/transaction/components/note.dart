import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/separated/component.dart";

class TransactionNoteComponent extends StatelessWidget {
  final String note;

  const TransactionNoteComponent({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
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
