import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1728991478AddColorAndBalanceColumnsToAccounts
    extends BaseMigration {
  final _table = "accounts";

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();
    batch.execute("ALTER TABLE $_table "
        "ADD COLUMN color_name TEXT DEFAULT '' NOT NULL;");
    batch.execute("ALTER TABLE $_table "
        "ADD COLUMN balance REAL DEFAULT 0 NOT NULL;");
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    final batch = db.batch();
    batch.execute("ALTER TABLE $_table DROP COLUMN color_name;");
    batch.execute("ALTER TABLE $_table DROP COLUMN balance;");
    await batch.commit();
  }
}
