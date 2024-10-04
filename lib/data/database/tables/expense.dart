import "package:drift/drift.dart";
import "package:mony_app/data/database/tables/account.dart";
import "package:mony_app/data/database/tables/base_table.dart";
import "package:mony_app/data/database/tables/category.dart";

final class Expenses extends BaseTable {
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();

  RealColumn get amount => real()();

  TextColumn get account =>
      text().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get category =>
      text().references(Categories, #id, onDelete: KeyAction.cascade)();

  TextColumn get note => text()();
}
