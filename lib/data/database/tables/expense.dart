import "package:drift/drift.dart";
import "package:mony_app/common/extensions/string.dart";
import "package:mony_app/data/database/tables/account.dart";
import "package:mony_app/data/database/tables/category.dart";

final class Expenses extends Table {
  @override
  Set<TextColumn> get primaryKey => {id};

  TextColumn get id => text().clientDefault(() => ExString.random(20))();

  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updated => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();

  RealColumn get amount => real()();

  TextColumn get account =>
      text().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get category =>
      text().references(Categories, #id, onDelete: KeyAction.cascade)();

  TextColumn get note => text()();
}
