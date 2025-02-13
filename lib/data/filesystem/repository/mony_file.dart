import "dart:convert";
import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";

abstract base class MonyFileFilesystemRepository {
  const factory MonyFileFilesystemRepository({required FilePicker filePicker}) =
      _Impl;

  Future<String?> read();

  Future<void> write(String data);
}

final class _Impl implements MonyFileFilesystemRepository {
  final FilePicker filePicker;

  const _Impl({required this.filePicker});

  String get fileExtension => "json";

  @override
  Future<String?> read() async {
    try {
      final result = await filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fileExtension],
      );
      if (result == null) return null;
      final platformFile = result.files.single;
      if (platformFile.path == null) return null;
      final file = File(platformFile.path!);
      return file.readAsString();
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  @override
  Future<void> write(String data) async {
    try {
      await filePicker.saveFile(
        fileName: "export_mony.$fileExtension",
        type: FileType.custom,
        allowedExtensions: [fileExtension],
        bytes: Uint8List.fromList(utf8.encode(data)),
      );
    } catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
