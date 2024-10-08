import "package:mony_app/data/database/migration_service.dart";
import "package:mony_app/domain/domain.dart";
import "package:sqflite/sqflite.dart";

typedef _IndexValueObject = ({String table, List<String> columns, bool unique});

final class M1728167641Init extends BaseMigration {
  // defaults
  final _defaultExpenseType = EExpenseType.defaultValue.value;
  final _defaultAccountType = EAccountType.defaultValue.value;
  final _defaultCurrencyCode = "RUB";

  // tables and columns
  // ACCOUNTS
  final _accounts = "accounts";
  final _accountsTitle = "title";
  final _accountsType = "type";
  final _accountsCurrencyCode = "currency_code";
  // CATEGORIES
  final _categories = "categories";
  final _categoriesTitle = "title";
  final _categoriesIcon = "icon";
  final _categoriesSort = "sort";
  final _categoriesColor = "color";
  final _categoriesExpenseType = "expense_type";
  // EXPENSES
  final _expenses = "expenses";
  final _expensesAmount = "amount";
  final _expensesType = "type";
  final _expensesDate = "date";
  final _expensesNote = "note";
  final _expensesAccountId = "account_id";
  final _expensesCategoryId = "category_id";
  // TAGS
  final _tags = "tags";
  final _tagsTitle = "title";
  // EXPENSE TAGS
  final _expenseTags = "expense_tags";
  final _expenseTagsExpenseId = "expense_id";
  final _expenseTagsTagId = "tag_id";

  // indexes
  late final _indexes = <_IndexValueObject>[
    (table: _accounts, columns: [_accountsTitle, _accountsType], unique: true),
    (table: _categories, columns: [_categoriesExpenseType], unique: false),
    (
      table: _categories,
      columns: [_categoriesTitle, _categoriesIcon, _categoriesExpenseType],
      unique: true
    ),
    (table: _expenses, columns: [_expensesAccountId], unique: false),
    (table: _expenses, columns: [_expensesCategoryId], unique: false),
    (
      table: _expenses,
      columns: [_expensesAccountId, _expensesCategoryId],
      unique: false
    ),
    (
      table: _expenseTags,
      columns: [_expenseTagsExpenseId, _expenseTagsTagId],
      unique: true
    ),
  ];

  // queries
  late final _accountsQuery = """
CREATE TABLE $_accounts (
	$defaultColumns,
	$_accountsTitle        TEXT DEFAULT ''                      NOT NULL,
	$_accountsType         TEXT DEFAULT '$_defaultAccountType'  NOT NULL,
	$_accountsCurrencyCode TEXT DEFAULT '$_defaultCurrencyCode' NOT NULL
);
""";

  late final _categoryQuery = """
CREATE TABLE $_categories (
	$defaultColumns,
	$_categoriesTitle       TEXT    DEFAULT ''                     NOT NULL,
	$_categoriesIcon        TEXT    DEFAULT ''                     NOT NULL,
	$_categoriesSort        INTEGER DEFAULT 0                      NOT NULL,
	$_categoriesColor       TEXT    DEFAULT '0xFFFFFFFF'           NOT NULL,
	$_categoriesExpenseType TEXT    DEFAULT '$_defaultExpenseType' NOT NULL
);
""";

  late final _expensesQuery = """
CREATE TABLE $_expenses (
	$defaultColumns,
	$_expensesAmount     REAL DEFAULT 0                      NOT NULL,
	$_expensesType       TEXT DEFAULT '$_defaultExpenseType' NOT NULL,
	$_expensesDate       TEXT DEFAULT ''                     NOT NULL,
	$_expensesNote       TEXT DEFAULT ''                     NOT NULL,
	$_expensesAccountId  TEXT DEFAULT ''                     NOT NULL,
	$_expensesCategoryId TEXT DEFAULT ''                     NOT NULL,

	FOREIGN KEY ($_expensesAccountId)  REFERENCES $_accounts   (id) ON DELETE CASCADE,
	FOREIGN KEY ($_expensesCategoryId) REFERENCES $_categories (id) ON DELETE CASCADE
);
""";

  late final _tagsQuery = """
CREATE TABLE $_tags (
	$defaultColumns,
	$_tagsTitle TEXT UNIQUE DEFAULT '' NOT NULL
);
""";

  late final _expenseTagsQuery = """
CREATE TABLE $_expenseTags (
	$defaultColumns,
	$_expenseTagsExpenseId TEXT DEFAULT '' NOT NULL,
	$_expenseTagsTagId     TEXT DEFAULT '' NOT NULL,

	FOREIGN KEY ($_expenseTagsExpenseId) REFERENCES $_expenses (id) ON DELETE CASCADE,
	FOREIGN KEY ($_expenseTagsTagId)     REFERENCES $_tags     (id) ON DELETE CASCADE
);
""";

  String _getIndexName({required String table, required List<String> columns}) {
    return "_${table}__${columns.join("__")}_idx";
  }

  String _createIndex({
    required String table,
    required List<String> columns,
    required bool unique,
  }) {
    if (columns.isEmpty) {
      throw ArgumentError.value(
        columns,
        "MIGRATION: Columns should contain at least one column",
      );
    }
    final indexName = _getIndexName(table: table, columns: columns);
    return """
CREATE ${unique ? "UNIQUE" : ""} INDEX $indexName
ON $table (${columns.join(", ")});
""";
  }

  String _dropTable(String table) {
    return "DROP TABLE IF EXISTS $table;";
  }

  String _dropIndex({required String table, required List<String> columns}) {
    final indexName = _getIndexName(table: table, columns: columns);
    return "DROP INDEX IF EXISTS $indexName;";
  }

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();
    final tables = [
      _accountsQuery,
      _categoryQuery,
      _expensesQuery,
      _tagsQuery,
      _expenseTagsQuery,
    ];
    for (final tableQuery in tables) {
      batch.execute(tableQuery);
    }
    for (final index in _indexes) {
      batch.execute(
        _createIndex(
          table: index.table,
          columns: index.columns,
          unique: index.unique,
        ),
      );
    }
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    final batch = db.batch();
    // drop indexes
    for (final index in _indexes) {
      batch.execute(_dropIndex(table: index.table, columns: index.columns));
    }
    // drop tables
    final tables = [
      _expenseTags,
      _tags,
      _expenses,
      _categories,
      _accounts,
    ];
    for (final table in tables) {
      batch.execute(_dropTable(table));
    }
    await batch.commit();
  }
}
