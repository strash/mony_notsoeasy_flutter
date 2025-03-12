import "dart:io" show Platform;

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_rustore_review/flutter_rustore_review.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/data/data.dart";
import "package:mony_app/data/database/migrations/m_1728413017_seed_default_categories.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

// TODO: добавить вибрации тут и там при тапе
// TODO: бюджеты
// TODO: вход по отпечатку
// TODO: локализация
// TODO: контекстное меню для айтемов в списках
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GoogleFonts.config.allowRuntimeFetching = false;
  if (appFlavor == "prod_rustore_flavor") {
    await RustoreReviewClient.initialize();
  }
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  final appDatabase = AppDatabase.instance();
  await appDatabase.db;

  final accountRepo = AccountDatabaseRepository(database: appDatabase);
  final categoryRepo = CategoryDatabaseRepository(
    database: appDatabase,
    defaultCategoryMigration: M1728413017SeedDefaultCategories(),
  );
  final tagRepo = TagDatabaseRepository(database: appDatabase);
  final transactionRepo = TransactionDatabaseRepository(database: appDatabase);
  final transactionTagRepo = TransactionTagDatabaseRepository(
    database: appDatabase,
  );

  final sharedPrefRepo = SharedPreferencesLocalStorageRepository(
    preferences: SharedPreferencesAsync(),
  );

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
                monyFileFilesystemRepository: MonyFileFilesystemRepository(
                  filePicker: FilePicker.platform,
                ),
              );
            },
          ),

          // -> shared preferences service
          Provider<DomainSharedPreferencesService>(
            create: (context) {
              return DomainSharedPreferencesService(
                sharedPrefencesRepository: sharedPrefRepo,
              );
            },
          ),

          // -> app review service
          Provider<AppReviewService>(
            create: (context) {
              return AppReviewService(
                sharedPreferencesRepository: sharedPrefRepo,
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
