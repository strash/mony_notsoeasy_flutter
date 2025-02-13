final class ImportedCsvVO {
  final List<String> columns;
  final List<Map<String, String>> entries;

  const ImportedCsvVO({required this.columns, required this.entries});
}
