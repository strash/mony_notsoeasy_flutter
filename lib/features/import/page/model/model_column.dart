part of "./base_model.dart";

final class ImportModelColumn extends ImportModel {
  final EImportColumn column;
  final String? columnKey;

  ImportModelColumn({required this.column, required this.columnKey});

  ImportModelColumn copyWith({String? value}) {
    return ImportModelColumn(column: column, columnKey: value);
  }

  @override
  bool isReady() {
    return column.isRequired && columnKey != null || !column.isRequired;
  }

  @override
  void dispose() {}
}
