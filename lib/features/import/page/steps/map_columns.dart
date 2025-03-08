import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

class ImportMapColumnsComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapColumnsComponent({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final csvModel = viewModel.steps.whereType<ImportModelCsv>().firstOrNull;
    if (csvModel == null) throw ArgumentError.value(csvModel);
    final onRotateEntryPressed = viewModel<OnRotateEntryPressed>();
    final onInfoPressed = viewModel<OnColumnInfoPressed>();
    final numberOfEntries = csvModel.numberOfEntries;
    final numberOfEntriesDescription = csvModel.numberOfEntriesDescription(
      locale.languageCode,
    );
    final currentMappedColumn = viewModel.currentStep as ImportModelColumn;
    final count = numberOfEntries > 0 ? viewModel.currentEntryIndex + 1 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  // -> icon info
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onInfoPressed(context),
                    child: SvgPicture.asset(
                      Assets.icons.infoCircle,
                      width: 25.0,
                      height: 25.0,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // -> title
                  NumericText(
                    'Колонка "${currentMappedColumn.column.title}"',
                    style: GoogleFonts.golosText(
                      fontSize: 20.0,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // -> asterisk
                  if (currentMappedColumn.column.isRequired)
                    Text(
                      " *",
                      style: GoogleFonts.golosText(
                        fontSize: 20.0,
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15.0),

              // -> description
              NumericText(
                "Выбери подходящую колонку,\n"
                "значение в которой подходит\n"
                'к колонке "${currentMappedColumn.column.title}".',
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  height: 1.3,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),

        // -> csv table
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: EntryListComponent(event: event),
        ),
        const SizedBox(height: 5.0),

        // button rotate entries
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onRotateEntryPressed(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Следующая запись",
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      NumericText(
                        "$count из "
                        "$numberOfEntriesDescription",
                        style: GoogleFonts.golosText(
                          fontSize: 12.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
