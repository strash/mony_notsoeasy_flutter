import "package:mony_app/common/common.dart";
import "package:mony_app/data/database/migration_service.dart";
import "package:mony_app/domain/domain.dart";
import "package:sqflite/sqflite.dart";

typedef _IndexValueObject = ({String table, List<String> columns, bool unique});

final class M1728167641Init extends BaseMigration {
  // defaults
  final _defaultTransactionType = ETransactionType.defaultValue.value;
  final _defaultAccountType = EAccountType.defaultValue.value;
  final _defaultCurrencyCode = kDefaultCurrencyCode;

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
  final _categoriesTransactionType = "transaction_type";
  // TRANSACTIONS
  final _transactions = "transactions";
  final _transactionsAmount = "amount";
  final _transactionsType = "type";
  final _transactionsDate = "date";
  final _transactionsNote = "note";
  final _transactionsAccountId = "account_id";
  final _transactionssCategoryId = "category_id";
  // TAGS
  final _tags = "tags";
  final _tagsTitle = "title";
  // TRANSACTION TAGS
  final _transactionTags = "transaction_tags";
  final _transactionTagsTransactionId = "transaction_id";
  final _transactionTagsTagId = "tag_id";

  // indexes
  late final _indexes = <_IndexValueObject>[
    (table: _accounts, columns: [_accountsTitle, _accountsType], unique: true),
    (table: _categories, columns: [_categoriesTransactionType], unique: false),
    (
      table: _categories,
      columns: [_categoriesTitle, _categoriesIcon, _categoriesTransactionType],
      unique: true
    ),
    (table: _transactions, columns: [_transactionsAccountId], unique: false),
    (table: _transactions, columns: [_transactionssCategoryId], unique: false),
    (
      table: _transactions,
      columns: [_transactionsAccountId, _transactionssCategoryId],
      unique: false
    ),
    (
      table: _transactionTags,
      columns: [_transactionTagsTransactionId, _transactionTagsTagId],
      unique: true
    ),
  ];

  // queries
  late final _accountsQuery = """
CREATE TABLE IF NOT EXISTS $_accounts (
	$defaultColumns,
	$_accountsTitle        TEXT DEFAULT ''                      NOT NULL,
	$_accountsType         TEXT DEFAULT '$_defaultAccountType'  NOT NULL,
	$_accountsCurrencyCode TEXT DEFAULT '$_defaultCurrencyCode' NOT NULL
);
""";

  late final _categoryQuery = """
CREATE TABLE IF NOT EXISTS $_categories (
	$defaultColumns,
	$_categoriesTitle           TEXT    DEFAULT ''                     NOT NULL,
	$_categoriesIcon            TEXT    DEFAULT ''                     NOT NULL,
	$_categoriesSort            INTEGER DEFAULT 0                      NOT NULL,
	$_categoriesColor           TEXT    DEFAULT '0xFFFFFFFF'           NOT NULL,
	$_categoriesTransactionType TEXT    DEFAULT '$_defaultTransactionType' NOT NULL
);
""";

  late final _transictonsQuery = """
CREATE TABLE IF NOT EXISTS $_transactions (
	$defaultColumns,
	$_transactionsAmount      REAL DEFAULT 0                          NOT NULL,
	$_transactionsType        TEXT DEFAULT '$_defaultTransactionType' NOT NULL,
	$_transactionsDate        TEXT DEFAULT ''                         NOT NULL,
	$_transactionsNote        TEXT DEFAULT ''                         NOT NULL,
	$_transactionsAccountId   TEXT DEFAULT ''                         NOT NULL,
	$_transactionssCategoryId TEXT DEFAULT ''                         NOT NULL,

	FOREIGN KEY ($_transactionsAccountId)   REFERENCES $_accounts   (id) ON DELETE CASCADE,
	FOREIGN KEY ($_transactionssCategoryId) REFERENCES $_categories (id) ON DELETE CASCADE
);
""";

  late final _tagsQuery = """
CREATE TABLE IF NOT EXISTS $_tags (
	$defaultColumns,
	$_tagsTitle TEXT UNIQUE DEFAULT '' NOT NULL
);
""";

  late final _transactionTagsQuery = """
CREATE TABLE IF NOT EXISTS $_transactionTags (
	$defaultColumns,
	$_transactionTagsTransactionId TEXT DEFAULT '' NOT NULL,
	$_transactionTagsTagId         TEXT DEFAULT '' NOT NULL,

	FOREIGN KEY ($_transactionTagsTransactionId) REFERENCES $_transactions (id) ON DELETE CASCADE,
	FOREIGN KEY ($_transactionTagsTagId)         REFERENCES $_tags         (id) ON DELETE CASCADE
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
CREATE ${unique ? "UNIQUE" : ""} INDEX IF NOT EXISTS $indexName
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
      _transictonsQuery,
      _tagsQuery,
      _transactionTagsQuery,
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
      _transactionTags,
      _tags,
      _transactions,
      _categories,
      _accounts,
    ];
    for (final table in tables) {
      batch.execute(_dropTable(table));
    }
    await batch.commit();
  }
}
