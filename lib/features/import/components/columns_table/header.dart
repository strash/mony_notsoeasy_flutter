import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/features/import/components/components.dart";

class EntryListHeaderComponent extends StatelessWidget {
  const EntryListHeaderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // -> columns
        SizedBox(
          width: EntryListComponent.columnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Колонки",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 14.0,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: EntryListComponent.columnGap),

        // -> values
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Значения",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.golosText(
                    fontSize: 14.0,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
