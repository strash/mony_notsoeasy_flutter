import "package:drift/drift.dart";
import "package:mony_app/data/database/tables/base_table.dart";
import "package:mony_app/data/database/tables/expense.dart";
import "package:mony_app/data/database/tables/tag.dart";

final class ExpenseTags extends BaseTable {
  TextColumn get expense =>
      text().references(Expenses, #id, onDelete: KeyAction.cascade)();

  TextColumn get tag =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();
}
