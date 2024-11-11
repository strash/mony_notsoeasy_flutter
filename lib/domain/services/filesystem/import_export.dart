import "package:csv/csv.dart";
import "package:mony_app/data/filesystem/filesystem.dart";
import "package:mony_app/domain/services/database/vo/imported_csv.dart";

final class DomainImportExportService {
  final CsvFilesystemRepository _csvFilesystemRepository;

  DomainImportExportService({
    required CsvFilesystemRepository csvFilesystemRepository,
  }) : _csvFilesystemRepository = csvFilesystemRepository;

  Future<ImportedCsvVO?> read() async {
    final content = await _csvFilesystemRepository.read();
    if (content == null) return null;
    const converter = CsvToListConverter(
      convertEmptyTo: EmptyValue.NULL,
      shouldParseNumbers: false,
    );
    int lineIndex = 0;
    final columns = <String>[];
    final entries = <Map<String, String>>[];
    await for (final line in content.where((line) => line.isNotEmpty)) {
      if (lineIndex == 0) {
        final entry = converter.convert<String>(line).firstOrNull;
        if (entry != null) columns.addAll(entry);
      } else {
        final entry = converter.convert<String>(line).firstOrNull;
        if (entry != null && columns.length == entry.length) {
          final Map<String, String> map = {};
          for (int index = 0; index < entry.length; index++) {
            map[columns.elementAt(index)] = entry.elementAt(index);
          }
          entries.add(map);
        }
      }
      ++lineIndex;
    }
    return ImportedCsvVO(columns: columns, entries: entries);
  }
}
