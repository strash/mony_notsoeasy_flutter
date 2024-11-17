part of "./base_model.dart";

final class ImportModelColumnValidation extends ImportModel {
  final ImportModelCsv csvModel;
  final List<ImportModelColumn> columns;
  final results = ValueNotifier<List<ValidationResult>>([]);
  List<Map<ImportModelColumn, String>> mappedEntries = [];

  ImportModelColumnValidation({
    required this.csvModel,
    required this.columns,
  }) {
    mappedEntries = _mapEntries();
  }

  List<Map<ImportModelColumn, String>> _mapEntries() {
    final csv = csvModel.csv;
    if (csv == null) throw ArgumentError.notNull();
    final cols = mappedColumns;
    final List<Map<ImportModelColumn, String>> res = [];
    for (final row in csv.entries) {
      final Map<ImportModelColumn, String> mapped = {};
      for (final MapEntry(key: column, :value) in row.entries) {
        final col = cols.where((e) => e.columnKey == column).firstOrNull;
        if (col == null) continue;
        mapped[col] = value;
      }
      res.add(mapped);
    }
    return res;
  }

  List<ImportModelColumn> get mappedColumns {
    return columns.where((e) => e.columnKey != null).toList(growable: false);
  }

  Future<void> validate() async {
    final csv = csvModel.csv;
    if (csv == null) throw ArgumentError.notNull();
    for (final column in mappedColumns) {
      await Future.delayed(const Duration(milliseconds: 100));
      final entryKey = column.columnKey!;
      final validator = switch (column.column) {
        EImportColumn.account => AccountValidator(),
        EImportColumn.amount => AmountValidator(),
        EImportColumn.transactionType => TransactionTypeValidator(),
        EImportColumn.date => DateValidator(),
        EImportColumn.category => CategoryValidator(),
        EImportColumn.tag => TagValidator(),
        EImportColumn.note => NoteValidator(),
      };
      final result = validator.validate(csv.entries, entryKey);
      results.value = List<ValidationResult>.from(results.value)..add(result);
    }
  }

  @override
  bool isReady() {
    final allValidated = results.value.length == mappedColumns.length;
    return allValidated && results.value.every((e) => e.ok != null);
  }

  @override
  void dispose() {
    results.dispose();
  }
}
