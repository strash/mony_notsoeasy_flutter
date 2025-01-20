import "dart:convert";
import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";

abstract base class CsvFilesystemRepository {
  const factory CsvFilesystemRepository({
    required FilePicker filePicker,
  }) = _Impl;

  Future<Stream<String>?> read();
}

final class _Impl implements CsvFilesystemRepository {
  final FilePicker filePicker;

  const _Impl({required this.filePicker});

  String get fileExtension => "csv";

  @override
  Future<Stream<String>?> read() async {
    try {
      final result = await filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fileExtension],
      );
      if (result == null) return null;
      final platformFile = result.files.single;
      if (platformFile.path == null) return null;
      final file = File(platformFile.path!);
      return file
          .openRead()
          .transform<String>(utf8.decoder)
          .transform<String>(const LineSplitter());
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
