import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/data/database/database.dart";
import "package:mony_app/data/filesystem/filesystem.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDatabase = AppDatabase.instance();
  await appDatabase.db;

  runApp(
    AppEventServiceBuilder(
      child: MultiProvider(
        providers: [
          // -> import/export service
          Provider<ImportExportService>(
            create: (context) {
              return ImportExportService(
                csvFilesystemRepository: CsvFilesystemRepository(
                  filePicker: FilePicker.platform,
                ),
              );
            },
          ),

          // -> account service
          Provider<AccountService>(
            create: (context) {
              return AccountService(
                accountRepo: AccountDatabaseRepository(database: appDatabase),
                accountFactory: AccountDatabaseFactoryImpl(),
              );
            },
          ),
        ],
        child: const MonyApp(),
      ),
    ),
  );
}
