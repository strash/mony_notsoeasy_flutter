import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1728167641Init extends BaseMigration {
  late final _accounts = """
CREATE TABLE accounts (
	$defaultColumns,
	title         TEXT DEFAULT ''    NOT NULL,
	type          TEXT DEFAULT ''    NOT NULL,
	currency_code TEXT DEFAULT 'RUB' NOT NULL
);
""";

  late final _category = """
CREATE TABLE categories (
	$defaultColumns,
	title TEXT DEFAULT '' NOT NULL,
	icon  TEXT DEFAULT '' NOT NULL
);
""";

  late final _expenses = """
CREATE TABLE expenses (
	$defaultColumns,
	amount      REAL DEFAULT 0  NOT NULL,
	date        TEXT DEFAULT '' NOT NULL,
	note        TEXT DEFAULT '' NOT NULL,
	account_id  TEXT DEFAULT '' NOT NULL,
	category_id TEXT DEFAULT '' NOT NULL,

	FOREIGN KEY (account_id)  REFERENCES accounts   (id) ON DELETE CASCADE,
	FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
);
""";

  late final _tags = """
CREATE TABLE tags (
	$defaultColumns,
	title TEXT UNIQUE DEFAULT '' NOT NULL
);
""";

  late final _expenseTags = """
CREATE TABLE expense_tags (
	$defaultColumns,
	expense_id TEXT DEFAULT '' NOT NULL,
	tag_id     TEXT DEFAULT '' NOT NULL,

	FOREIGN KEY (expense_id) REFERENCES expenses (id) ON DELETE CASCADE,
	FOREIGN KEY (tag_id)     REFERENCES tags     (id) ON DELETE CASCADE
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
    // categories
    batch.execute(_category);
    batch.execute(createIndex("categories", ["title", "icon"]));
    // expenses
    batch.execute(_expenses);
    batch.execute(createIndex("expenses", ["account"], false));
    batch.execute(createIndex("expenses", ["category"], false));
    batch.execute(createIndex("expenses", ["account", "category"], false));
    // tags
    batch.execute(_tags);
    // expense tags
    batch.execute(_expenseTags);
    batch.execute(createIndex("expense_tags", ["expense", "tag"]));
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
