import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/data/data.dart";
import "package:mony_app/data/database/migrations/m_1728413017_seed_default_categories.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  final appDatabase = AppDatabase.instance();
  await appDatabase.db;

  final accountRepo = AccountDatabaseRepository(database: appDatabase);
  final categoryRepo = CategoryDatabaseRepository(
    database: appDatabase,
    defaultCategoryMigration: M1728413017SeedDefaultCategories(),
  );
  final tagRepo = TagDatabaseRepository(database: appDatabase);
  final transactionRepo = TransactionDatabaseRepository(database: appDatabase);
  final transactionTagRepo =
      TransactionTagDatabaseRepository(database: appDatabase);

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
          Provider<DomainSharedPreferencesService>(
            create: (context) {
              return DomainSharedPreferencesService(
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
                accountRepo: accountRepo,
                accountFactory: AccountDatabaseFactoryImpl(),
                accountBalanceFactory: AccountBalanceDatabaseFactoryImpl(),
              );
            },
          ),

          // -> category service
          Provider<DomainCategoryService>(
            create: (context) {
              return DomainCategoryService(
                categoryRepo: categoryRepo,
                categoryFactory: CategoryDatabaseFactoryImpl(),
                categoryBalanceFactory: CategoryBalanceDatabaseFactoryImpl(),
              );
            },
          ),

          // -> tag service
          Provider<DomainTagService>(
            create: (context) {
              return DomainTagService(
                tagRepo: tagRepo,
                tagFactory: TagDatabaseFactoryImpl(),
                tagBalanceFactory: TagBalanceDatabaseFactoryImpl(),
              );
            },
          ),

          // -> transaction service
          Provider<DomainTransactionService>(
            create: (context) {
              return DomainTransactionService(
                transactionRepo: transactionRepo,
                transactionTagRepo: transactionTagRepo,
                tagRepo: tagRepo,
                accountRepo: accountRepo,
                categoryRepo: categoryRepo,
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
