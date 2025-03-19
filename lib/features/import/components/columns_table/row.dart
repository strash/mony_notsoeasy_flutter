import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_numeric_text/flutter_numeric_text.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/features/import/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart";

class EntryListRowComponent extends StatelessWidget {
  final MapEntry<String, String> entry;
  final ImportEvent? event;

  const EntryListRowComponent({super.key, required this.entry, this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final column =
        viewModel.mappedColumns
            .where((e) => e.columnKey == entry.key)
            .firstOrNull;
    final activeColumn = viewModel.currentColumn;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 34.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final event = this.event;
          if (event == null) return;
          viewModel<OnColumnSelected>()(context, entry.key);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  // -> column
                  SizedBox(
                    width: EntryListComponent.columnWidth,
                    child: Text(
                      entry.key,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.golosText(
                        fontSize: 16.0,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: EntryListComponent.columnGap),

                  // -> value
                  Flexible(
                    child: NumericText(
                      entry.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.golosText(
                        fontSize: 16.0,
                        height: 1.4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -> selection
            AnimatedOpacity(
              duration: Durations.short2,
              opacity:
                  (activeColumn != null &&
                              activeColumn.columnKey == entry.key) ||
                          (column?.columnKey == entry.key)
                      ? 1.0
                      : 0.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7.0,
                  vertical: 3.0,
                ),
                child: Row(
                  children: [
                    SizedBox.fromSize(
                      size: const Size.fromWidth(
                        EntryListComponent.columnWidth + 16.0,
                      ),
                      child: TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: theme.colorScheme.secondary,
                          end:
                              column?.columnKey == entry.key
                                  ? theme.colorScheme.tertiary
                                  : theme.colorScheme.secondary,
                        ),
                        duration: Durations.short2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.t.models.import.column_title(
                                context:
                                    column?.column ??
                                    activeColumn?.column ??
                                    EImportColumn.defaultValue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.golosText(
                                fontSize: 15.0,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                        builder: (context, color, child) {
                          return DecoratedBox(
                            decoration: ShapeDecoration(
                              color: color,
                              shape: const SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.all(
                                  SmoothRadius(
                                    cornerRadius: 10.0,
                                    cornerSmoothing: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
