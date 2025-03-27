import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/i18n/strings.g.dart";

class TransactionNoteComponent extends StatelessWidget {
  final String note;

  const TransactionNoteComponent({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return SeparatedComponent.list(
      separatorBuilder: (context, index) => const SizedBox(height: 10.0),
      children: [
        // -> title
        Text(
          context.t.features.transaction.note_title,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: ColorScheme.of(context).onSurfaceVariant,
          ),
        ),

        // -> the note
        Text(
          note,
          style: GoogleFonts.golosText(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            height: 1.4,
            color: ColorScheme.of(context).onSurface,
          ),
        ),
      ],
    );
  }
}
