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
          Provider<DomainImportExportService>(
            create: (context) {
              return DomainImportExportService(
                csvFilesystemRepository: CsvFilesystemRepository(
                  filePicker: FilePicker.platform,
                ),
              );
            },
          ),

          // -> account service
          Provider<DomainAccountService>(
            create: (context) {
              return DomainAccountService(
                accountRepo: AccountDatabaseRepository(database: appDatabase),
                accountFactory: AccountDatabaseFactoryImpl(),
                accountBalanceFactory: AccountBalanceDatabaseFactoryImpl(),
              );
            },
          ),

          // -> category service
          Provider<DomainCategoryService>(
            create: (context) {
              return DomainCategoryService(
                categoryRepo: CategoryDatabaseRepository(database: appDatabase),
                categoryFactory: CategoryDatabaseFactoryImpl(),
              );
            },
          ),

          // -> tag service
          Provider<DomainTagService>(
            create: (context) {
              return DomainTagService(
                tagRepo: TagDatabaseRepository(database: appDatabase),
                tagFactory: TagDatabaseFactoryImpl(),
              );
            },
          ),

          // -> transaction service
          Provider<DomainTransactionService>(
            create: (context) {
              return DomainTransactionService(
                transactionRepo:
                    TransactionDatabaseRepository(database: appDatabase),
                transactionTagRepo:
                    TransactionTagDatabaseRepository(database: appDatabase),
                accountRepo: AccountDatabaseRepository(database: appDatabase),
                categoryRepo: CategoryDatabaseRepository(database: appDatabase),
                transactionFactory: TransactionDatabaseFactoryImpl(),
                transactionTagFactory: TransactionTagDatabaseFactoryImpl(),
                accountFactory: AccountDatabaseFactoryImpl(),
                categoryFactory: CategoryDatabaseFactoryImpl(),
              );
            },
          ),
        ],
        child: const MonyApp(),
      ),
    ),
  );
}
