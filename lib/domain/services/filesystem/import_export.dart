import "dart:convert";

import "package:csv/csv.dart";
import "package:mony_app/data/filesystem/filesystem.dart";
import "package:mony_app/domain/services/database/vo/imported_csv.dart";

final class DomainImportExportService {
  final CsvFilesystemRepository _csvRepo;
  final MonyFileFilesystemRepository _monyFileRepo;

  DomainImportExportService({
    required CsvFilesystemRepository csvFilesystemRepository,
    required MonyFileFilesystemRepository monyFileFilesystemRepository,
  }) : _csvRepo = csvFilesystemRepository,
       _monyFileRepo = monyFileFilesystemRepository;

  Future<ImportedCsvVO?> importCSV() async {
    final content = await _csvRepo.read();
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

  Future<Map<String, dynamic>?> importMONY() async {
    final content = await _monyFileRepo.read();
    if (content == null) return null;
    final data = jsonDecode(content);
    if (data is Map<String, dynamic>) return data;
    return null;
  }

  Future<void> exportData(Map<String, dynamic> data) async {
    await _monyFileRepo.write(jsonEncode(data));
  }
}
