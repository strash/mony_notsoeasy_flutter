import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";
import "package:mony_app/data/database/tables/account.dart";
import "package:mony_app/data/database/tables/category.dart";
import "package:mony_app/data/database/tables/expense.dart";
import "package:mony_app/data/database/tables/expense_tag.dart";
import "package:mony_app/data/database/tables/tag.dart";

part "database.g.dart";

@DriftDatabase(tables: [Accounts, Categories, Tags, Expenses, ExpenseTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: "mony_app");
  }
}
