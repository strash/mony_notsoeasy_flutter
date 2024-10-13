import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/data/database/database.dart";
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
