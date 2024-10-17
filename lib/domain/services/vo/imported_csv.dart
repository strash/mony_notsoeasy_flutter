import "package:freezed_annotation/freezed_annotation.dart";

part "imported_csv.freezed.dart";

@freezed
class ImportedCsvValueObject with _$ImportedCsvValueObject {
  const factory ImportedCsvValueObject({
    required List<String> columns,
    required List<Map<String, String>> entries,
  }) = _ImportedCsvValueObject;
}

typedef TMappedCsvColumn = ({String name, String? value});

@freezed
class MappedCsvColumnsValueObject with _$MappedCsvColumnsValueObject {
  const factory MappedCsvColumnsValueObject({
    required String? account,
    required String? amount,
    required String? expenseType,
    required String? date,
    required String? category,
    required String? tag,
    required String? note,
  }) = _MappedCsvColumnsValueObject;
}
