import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1728167641Init extends BaseMigration {
  late final _accounts = """
CREATE TABLE accounts (
	$defaultColumns,
	title TEXT DEFAULT '' NOT NULL,
	type  TEXT DEFAULT '' NOT NULL
);
""";

  late final _category = """
CREATE TABLE categories (
	$defaultColumns,
	title TEXT NOT NULL,
	icon  TEXT DEFAULT ''
);
""";

  late final _expenses = """
CREATE TABLE expenses (
	$defaultColumns,
	amount   REAL DEFAULT 0  NOT NULL,
	date     TEXT            NOT NULL,
	note     TEXT DEFAULT '' NOT NULL,
	account  TEXT            NOT NULL,
	category TEXT,

	FOREIGN KEY (account)  REFERENCES accounts   (id) ON DELETE CASCADE,
	FOREIGN KEY (category) REFERENCES categories (id) ON DELETE CASCADE
);
""";

  late final _tags = """
CREATE TABLE tags (
	$defaultColumns,
	title TEXT UNIQUE NOT NULL
);
""";

  late final _expenseTags = """
CREATE TABLE expense_tags (
	$defaultColumns,
	expense TEXT NOT NULL,
	tag TEXT NOT NULL,

	FOREIGN KEY (expense) REFERENCES expenses (id) ON DELETE CASCADE,
	FOREIGN KEY (tag)     REFERENCES tags     (id) ON DELETE CASCADE
);
""";

  String _drop(String table) {
    return "DROP TABLE IF EXISTS $table;";
  }

  @override
  Future<void> up(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    // accounts
    batch.execute(_accounts);
    batch.execute(createIndex("accounts", ["title", "type"]));
    batch.execute(createTriggerToUpdateUpdated("accounts"));
    // categories
    batch.execute(_category);
    batch.execute(createIndex("categories", ["title", "icon"]));
    batch.execute(createTriggerToUpdateUpdated("categories"));
    // expenses
    batch.execute(_expenses);
    batch.execute(createIndex("expenses", ["account"]));
    batch.execute(createIndex("expenses", ["category"]));
    batch.execute(createIndex("expenses", ["account", "category"]));
    batch.execute(createTriggerToUpdateUpdated("expenses"));
    // tags
    batch.execute(_tags);
    batch.execute(createTriggerToUpdateUpdated("tags"));
    // expense tags
    batch.execute(_expenseTags);
    batch.execute(createIndex("expense_tags", ["expense", "tag"]));
    batch.execute(createTriggerToUpdateUpdated("expense_tags"));
    await batch.commit();
  }

  @override
  Future<void> down(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    final tables = [
      "expense_tags",
      "tags",
      "expenses",
      "categories",
      "accounts",
    ];
    for (final table in tables) {
      _drop(table);
    }
    await batch.commit();
  }
}
