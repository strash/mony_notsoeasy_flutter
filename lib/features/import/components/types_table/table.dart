import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/features/import/page/view_model.dart";

class TypesTableComponent extends StatelessWidget {
  final ImportModelTransactionTypeVO transactionsByType;

  TypesTableComponent({super.key, required this.transactionsByType})
    : assert(
        transactionsByType.entries.isNotEmpty,
        "Entries shouldn't be empty",
      );

  List<MapEntry<ImportModelColumn, String>> _getFilteredEntries(
    Map<ImportModelColumn, String> entry,
  ) {
    final List<MapEntry<ImportModelColumn, String>> entries = [];
    for (final MapEntry(key: col, :value) in entry.entries) {
      if (!col.column.isRequired &&
          col.column != EImportColumn.transactionType) {
        continue;
      }
      entries.add(MapEntry(col, value));
    }
    return entries;
  }

  Map<int, TableColumnWidth> _getColumnWidths(
    List<MapEntry<ImportModelColumn, String>> entry,
  ) {
    final Map<int, TableColumnWidth> columnWidths = {};
    for (final (index, MapEntry(:key)) in entry.indexed) {
      final double fraction;
      if (key.column == EImportColumn.date) {
        fraction = 0.6;
      } else if (key.column == EImportColumn.amount) {
        fraction = 0.5;
      } else if (key.column == EImportColumn.transactionType) {
        fraction = 0.58;
      } else {
        fraction = 0.75;
      }
      columnWidths[index] = FlexColumnWidth(fraction);
    }
    return columnWidths;
  }

  EdgeInsets _getPadding(int index, int length) {
    const hor = 7.0;
    const ver = 10.0;
    final EdgeInsets padding;
    if (index == 0) {
      padding = const EdgeInsets.fromLTRB(0.0, ver, hor, ver);
    } else if (index + 1 == length) {
      padding = const EdgeInsets.fromLTRB(10.0, ver, hor, ver);
    } else {
      padding = const EdgeInsets.symmetric(horizontal: hor, vertical: ver);
    }
    return padding;
  }

  String _getFormattedValue(
    String locale,
    MapEntry<ImportModelColumn, String> entry,
  ) {
    final dateFormatter = DateFormat("dd-MM-yyyy", locale);
    final amountFormatter = NumberFormat.compact(locale: locale);
    final String value;
    if (entry.key.column == EImportColumn.date) {
      value = dateFormatter.format(DateTime.parse(entry.value));
    } else if (entry.key.column == EImportColumn.amount) {
      value = amountFormatter.format(double.parse(entry.value));
    } else {
      value = entry.value;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredMappedEntries = transactionsByType.entries
        .take(5)
        .map(_getFilteredEntries)
        .toList(growable: false);

    final locale = Localizations.localeOf(context);

    return Table(
      columnWidths: _getColumnWidths(filteredMappedEntries.first),
      children: [
        // -> headers
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outline),
            ),
          ),
          children: filteredMappedEntries.first.indexed
              .map((e) {
                return TableCell(
                  child: Padding(
                    padding: _getPadding(
                      e.$1,
                      filteredMappedEntries.first.length,
                    ),
                    child: Text(
                      e.$2.key.column.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign:
                          e.$2.key.column == EImportColumn.amount
                              ? TextAlign.right
                              : TextAlign.left,
                      style: GoogleFonts.golosText(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                );
              })
              .toList(growable: false),
        ),

        // -> rows
        ...filteredMappedEntries.map((e) {
          return TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            children: e.indexed
                .map((r) {
                  return TableCell(
                    child: Padding(
                      padding: _getPadding(r.$1, e.length),
                      child: Text(
                        _getFormattedValue(locale.languageCode, r.$2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                            r.$2.key.column == EImportColumn.amount
                                ? TextAlign.right
                                : TextAlign.left,
                        style: GoogleFonts.golosText(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          );
        }),
      ],
    );
  }
}
