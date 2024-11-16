part of "./base_model.dart";

final class ImportModelColumn extends ImportModel {
  final EImportColumn column;
  final String? value;

  ImportModelColumn({
    required this.column,
    required this.value,
  });

  ImportModelColumn copyWith({String? value}) {
    return ImportModelColumn(
      column: column,
      value: value,
    );
  }

  @override
  bool isReady() {
    return column.isRequired && value != null || !column.isRequired;
  }

  @override
  void dispose() {}
}
