import "package:freezed_annotation/freezed_annotation.dart";

part "imported_csv.freezed.dart";

@freezed
class ImportedCsvVO with _$ImportedCsvVO {
  const factory ImportedCsvVO({
    required List<String> columns,
    required List<Map<String, String>> entries,
  }) = _ImportedCsvVO;
}
