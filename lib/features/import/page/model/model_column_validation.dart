part of "./base_model.dart";

final class ImportModelColumnValidation extends ImportModel {
  final ImportModelCsv csv;
  final List<ImportModelColumn> columns;
  final results = ValueNotifier<List<ValidationResult>>([]);

  ImportModelColumnValidation({
    required this.csv,
    required this.columns,
  });

  List<ImportModelColumn> get mappedColumns {
    return columns.where((e) => e.value != null).toList(growable: false);
  }

  Future<void> validate() async {
    final csv = this.csv.csv;
    if (csv == null) throw ArgumentError.notNull();
    for (final column in mappedColumns) {
      await Future.delayed(const Duration(milliseconds: 100));
      final entryKey = column.value!;
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
