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
import "package:mony_app/i18n/strings.g.dart";
import "package:shared_preferences/shared_preferences.dart";

// TODO: добавить вибрации тут и там при тапе
// TODO: бюджеты
// TODO: вход по отпечатку
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (appFlavor == "prod_rustore_flavor" || appFlavor == "dev_rustore_flavor") {
    await RustoreReviewClient.initialize();
  }
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  await AppDatabase.instance().db;

  runApp(
    AppEventServiceBuilder(
      child: ServiceLocator(
        services: [
          // -> import/export service
          () => DomainImportExportService(
            csvFilesystemRepository: CsvFilesystemRepository(
              filePicker: FilePicker.platform,
            ),
            monyFileFilesystemRepository: MonyFileFilesystemRepository(
              filePicker: FilePicker.platform,
            ),
          ),

          // -> shared preferences service
          () => DomainSharedPreferencesService(
            sharedPrefencesRepository: SharedPreferencesLocalStorageRepository(
              preferences: SharedPreferencesAsync(),
            ),
          ),

          // -> app review service
          () => AppReviewService(
            sharedPreferencesRepository:
                SharedPreferencesLocalStorageRepository(
                  preferences: SharedPreferencesAsync(),
                ),
          ),

          // -> account service
          () => DomainAccountService(
            accountRepo: AccountDatabaseRepository(
              database: AppDatabase.instance(),
            ),
            accountFactory: AccountDatabaseFactoryImpl(),
            accountBalanceFactory: AccountBalanceDatabaseFactoryImpl(),
          ),

          // -> category service
          () => DomainCategoryService(
            categoryRepo: CategoryDatabaseRepository(
              database: AppDatabase.instance(),
              defaultCategoryMigration: M1728413017SeedDefaultCategories(),
            ),
            categoryFactory: CategoryDatabaseFactoryImpl(),
            categoryBalanceFactory: CategoryBalanceDatabaseFactoryImpl(),
          ),

          // -> tag service
          () => DomainTagService(
            tagRepo: TagDatabaseRepository(database: AppDatabase.instance()),
            tagFactory: TagDatabaseFactoryImpl(),
            tagBalanceFactory: TagBalanceDatabaseFactoryImpl(),
          ),

          // -> transaction service
          () => DomainTransactionService(
            transactionRepo: TransactionDatabaseRepository(
              database: AppDatabase.instance(),
            ),
            transactionTagRepo: TransactionTagDatabaseRepository(
              database: AppDatabase.instance(),
            ),
            tagRepo: TagDatabaseRepository(database: AppDatabase.instance()),
            accountRepo: AccountDatabaseRepository(
              database: AppDatabase.instance(),
            ),
            categoryRepo: CategoryDatabaseRepository(
              database: AppDatabase.instance(),
              defaultCategoryMigration: M1728413017SeedDefaultCategories(),
            ),
            transactionFactory: TransactionDatabaseFactoryImpl(),
            tagFactory: TagDatabaseFactoryImpl(),
            accountFactory: AccountDatabaseFactoryImpl(),
            categoryFactory: CategoryDatabaseFactoryImpl(),
          ),
        ],
        child: TranslationProvider(child: const MonyApp()),
      ),
    ),
  );
}
