import "package:mony_app/data/database/migration_service.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:sqflite/sqflite.dart";

final class M1730475693RemoveTypeColumnFromTransactions extends BaseMigration {
  final String _table = "transactions";
  final _defaultTransactionType = ETransactionType.defaultValue.value;

  @override
  Future<void> up(Database db) async {
    await db.transaction((tx) async {
      await tx.execute("ALTER TABLE $_table DROP COLUMN type;");
    });
  }

  @override
  Future<void> down(Database db) async {
    await db.transaction((tx) async {
      await tx.execute("""
ALTER TABLE $_table ADD COLUMN
type TEXT DEFAULT '$_defaultTransactionType' NOT NULL;
""");
    });
  }
}
