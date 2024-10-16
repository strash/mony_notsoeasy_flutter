import "package:freezed_annotation/freezed_annotation.dart";

part "imported_csv.freezed.dart";

@freezed
class ImportedCsvValueObject with _$ImportedCsvValueObject {
  const factory ImportedCsvValueObject({
    required List<String> columns,
    required List<Map<String, String>> entries,
  }) = _ImportedCsvValueObject;
}
