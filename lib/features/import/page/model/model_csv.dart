part of "./base_model.dart";

final class ImportModelCsv extends ImportModel {
  final ImportedCsvVO? csv;

  ImportModelCsv({required this.csv});

  int get numberOfEntries {
    final csv = this.csv;
    if (csv == null) return 0;
    return csv.entries.length;
  }

  String get numberOfEntriesDescription {
    final count = numberOfEntries;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted запись",
      EWordCaseHint.genitive => "$formatted записи",
      EWordCaseHint.accusative => "$formatted записей",
    };
  }

  @override
  bool isReady() {
    return csv != null && csv!.entries.isNotEmpty;
  }

  @override
  void dispose() {}
}
