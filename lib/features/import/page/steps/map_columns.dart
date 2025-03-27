import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";
import "package:mony_app/i18n/strings.g.dart";

class ImportMapColumnsComponent extends StatelessWidget {
  final ImportEvent? event;

  const ImportMapColumnsComponent({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    final viewModel = context.viewModel<ImportViewModel>();
    final csvModel = viewModel.steps.whereType<ImportModelCsv>().firstOrNull;
    if (csvModel == null) throw ArgumentError.value(csvModel);

    final numberOfEntries = csvModel.numberOfEntries;
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
                    onTap: () => viewModel<OnColumnInfoPressed>()(context),
                    child: SvgPicture.asset(
                      Assets.icons.infoCircle,
                      width: 25.0,
                      height: 25.0,
                      colorFilter: ColorFilter.mode(
                        colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // -> title
                  Flexible(
                    child: Text(
                      context.t.features.import.map_columns.title(
                        context: currentMappedColumn.column,
                      ),
                      style: GoogleFonts.golosText(
                        fontSize: 20.0,
                        color: colorScheme.onSurface,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // -> asterisk
                  if (currentMappedColumn.column.isRequired)
                    Text(
                      " *",
                      style: GoogleFonts.golosText(
                        fontSize: 20.0,
                        color: colorScheme.error,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15.0),

              // -> description
              Text(
                context.t.features.import.map_columns.description(
                  context: currentMappedColumn.column,
                ),
                style: GoogleFonts.golosText(
                  fontSize: 15.0,
                  color: colorScheme.onSurfaceVariant,
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
        const SizedBox(height: 10.0),

        // button rotate entries
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => viewModel<OnRotateEntryPressed>()(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    spacing: 3.0,
                    children: [
                      Text(
                        context
                            .t
                            .features
                            .import
                            .map_columns
                            .button_rotate_entries
                            .title,
                        style: GoogleFonts.golosText(
                          fontSize: 16.0,
                          color: colorScheme.secondary,
                        ),
                      ),
                      Text(
                        context
                            .t
                            .features
                            .import
                            .map_columns
                            .button_rotate_entries
                            .description(count: count, n: numberOfEntries),
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          color: colorScheme.onSurfaceVariant,
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
