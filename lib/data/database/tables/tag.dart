import "package:drift/drift.dart";
import "package:mony_app/data/database/tables/base_table.dart";

final class Tags extends BaseTable {
  TextColumn get title => text().unique()();
}
