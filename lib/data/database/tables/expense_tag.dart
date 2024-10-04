import "package:drift/drift.dart";
import "package:mony_app/common/extensions/string.dart";
import "package:mony_app/data/database/tables/expense.dart";
import "package:mony_app/data/database/tables/tag.dart";

final class ExpenseTags extends Table {
  @override
  Set<TextColumn> get primaryKey => {id};

  TextColumn get id => text().clientDefault(() => ExString.random(20))();

  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updated => dateTime().withDefault(currentDateAndTime)();

  TextColumn get expense =>
      text().references(Expenses, #id, onDelete: KeyAction.cascade)();

  TextColumn get tag =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();
}
