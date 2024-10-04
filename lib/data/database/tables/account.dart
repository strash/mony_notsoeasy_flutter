import "package:drift/drift.dart";
import "package:mony_app/data/database/tables/base_table.dart";

enum AccountTableType { debit, credit, cash }

final class Accounts extends BaseTable {
  TextColumn get title => text()();

  TextColumn get type => textEnum<AccountTableType>()
      .withDefault(Constant(AccountTableType.debit.name))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {title, type},
      ];
}
