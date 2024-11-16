import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/import/page/view_model.dart";

class TypesTableComponent extends StatelessWidget {
  final TTransactionsByType transactionsByType;

  TypesTableComponent({
    super.key,
    required this.transactionsByType,
  }) : assert(
          transactionsByType.entriesByType.isNotEmpty,
          "Entries shouldn't be empty",
        );

  List<MapEntry<EImportColumn, String>> _getFilteredEntries(
    BuildContext context,
    Map<String, String> entry,
  ) {
    final viewModel = context.viewModel<ImportViewModel>();
    final List<MapEntry<EImportColumn, String>> entries = [];
    for (final element in entry.entries) {
      final column = viewModel.columns
          .where((e) => e.value == element.key)
          .firstOrNull
          ?.column;
      if (column == null ||
          !column.isRequired && column != EImportColumn.transactionType) {
        continue;
      }
      entries.add(MapEntry(column, element.value));
    }
    return entries;
  }

  Map<int, TableColumnWidth> _getColumnWidths(
    List<MapEntry<EImportColumn, String>> entry,
  ) {
    final Map<int, TableColumnWidth> columnWidths = {};
    for (final e in entry.indexed) {
      final double fraction;
      if (e.$2.key == EImportColumn.date) {
        fraction = 0.6;
      } else if (e.$2.key == EImportColumn.amount) {
        fraction = 0.5;
      } else if (e.$2.key == EImportColumn.transactionType) {
        fraction = 0.58;
      } else {
        fraction = 0.75;
      }
      columnWidths[e.$1] = FlexColumnWidth(fraction);
    }
    return columnWidths;
  }

  EdgeInsets _getPadding((int, MapEntry<EImportColumn, String>) e, int length) {
    final hor = 7.w;
    final ver = 10.h;
    final EdgeInsets padding;
    if (e.$1 == 0) {
      padding = EdgeInsets.fromLTRB(0.w, ver, hor, ver);
    } else if (e.$1 + 1 == length) {
      padding = EdgeInsets.fromLTRB(10.w, ver, hor, ver);
    } else {
      padding = EdgeInsets.symmetric(horizontal: hor, vertical: ver);
    }
    return padding;
  }

  String _getFormattedValue((int, MapEntry<EImportColumn, String>) entry) {
    final dateFormatter = DateFormat("dd-MM-yyyy");
    final amountFormatter = NumberFormat.compact();
    final String value;
    if (entry.$2.key == EImportColumn.date) {
      value = dateFormatter.format(DateTime.parse(entry.$2.value));
    } else if (entry.$2.key == EImportColumn.amount) {
      value = amountFormatter.format(double.parse(entry.$2.value));
    } else {
      value = entry.$2.value;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredMappedEntries = transactionsByType.entriesByType
        .take(5)
        .map((e) => _getFilteredEntries(context, e));

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
          children: filteredMappedEntries.first.indexed.map((e) {
            return TableCell(
              child: Padding(
                padding: _getPadding(e, filteredMappedEntries.first.length),
                child: Text(
                  e.$2.key.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: e.$2.key == EImportColumn.amount
                      ? TextAlign.right
                      : TextAlign.left,
                  style: GoogleFonts.golosText(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            );
          }).toList(growable: false),
        ),

        // -> rows
        ...filteredMappedEntries.map((e) {
          return TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            children: e.indexed.map((r) {
              return TableCell(
                child: Padding(
                  padding: _getPadding(r, e.length),
                  child: Text(
                    _getFormattedValue(r),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: r.$2.key == EImportColumn.amount
                        ? TextAlign.right
                        : TextAlign.left,
                    style: GoogleFonts.golosText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          );
        }),
      ],
    );
  }
}
