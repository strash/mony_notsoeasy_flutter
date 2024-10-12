import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/data/database/database.dart";
import "package:mony_app/domain/domain.dart";
import "package:provider/provider.dart";

final appNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "app_key");

class MonyApp extends StatelessWidget {
  final AppDatabase database;

  const MonyApp({
    super.key,
    required this.database,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393.0, 852.0),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          key: appNavigatorKey,
          title: "Mony App",
          routerDelegate: NavigatorDelegate(),
          // TODO: добавить смену темы через AppEventService
          // themeMode: ThemeMode.system,
          theme: lightTheme,
          darkTheme: darkTheme,
          supportedLocales: const [
            Locale("en", "EN"),
            Locale("ru", "RU"),
          ],
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MultiProvider(
              providers: [
                Provider<AccountService>(
                  create: (context) {
                    return AccountService(
                      accountRepo: AccountDatabaseRepository(
                        database: database,
                      ),
                      accountFactory: AccountDatabaseFactoryImpl(),
                    );
                  },
                ),
              ],
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
