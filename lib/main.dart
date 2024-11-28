import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/data/data.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

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

          // -> shared preferences service
          Provider<DomainSharedPrefenecesService>(
            create: (context) {
              return DomainSharedPrefenecesService(
                sharedPrefencesRepository:
                    SharedPreferencesLocalStorageRepository(
                  preferences: SharedPreferencesAsync(),
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
                categoryBalanceFactory: CategoryBalanceDatabaseFactoryImpl(),
              );
            },
          ),

          // -> tag service
          Provider<DomainTagService>(
            create: (context) {
              return DomainTagService(
                tagRepo: TagDatabaseRepository(database: appDatabase),
                tagFactory: TagDatabaseFactoryImpl(),
                tagBalanceFactory: TagBalanceDatabaseFactoryImpl(),
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
                tagRepo: TagDatabaseRepository(database: appDatabase),
                accountRepo: AccountDatabaseRepository(database: appDatabase),
                categoryRepo: CategoryDatabaseRepository(database: appDatabase),
                transactionFactory: TransactionDatabaseFactoryImpl(),
                tagFactory: TagDatabaseFactoryImpl(),
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
