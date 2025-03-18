part of "./base_model.dart";

final class ImportModelCsv extends ImportModel {
  final ImportedCsvVO? csv;

  ImportModelCsv({required this.csv});

  int get numberOfEntries {
    final csv = this.csv;
    if (csv == null) return 0;
    return csv.entries.length;
  }

  @override
  bool isReady() {
    return csv != null && csv!.entries.isNotEmpty;
  }

  @override
  void dispose() {}
}
