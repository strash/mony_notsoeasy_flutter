part of "./base_model.dart";

final class ImportModelCsv extends ImportModel {
  final ImportedCsvVO? csv;

  ImportModelCsv({required this.csv});

  @override
  bool isReady() {
    return csv != null && csv!.entries.isNotEmpty;
  }

  @override
  void dispose() {}
}
