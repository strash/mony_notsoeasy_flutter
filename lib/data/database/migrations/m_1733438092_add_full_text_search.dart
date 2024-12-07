import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1733438092AddFullTextSearch extends BaseMigration {
  final _accountsTable = "accounts";
  final _categoriesTable = "categories";
  final _tagsTable = "tags";
  final _transactionsTable = "transactions";
  final _transactionTagsTable = "transaction_tags";
  final _transactionsToFtsView = "_transactions_to_fts_view";

  late final _tables = [
    _accountsTable,
    _categoriesTable,
    _tagsTable,
    _transactionsTable,
  ];

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();

    // transactions to fts view
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_transactionsToFtsView(id, value) AS
SELECT
	tr.id,
	(tr.amount || ' ' || tr.note || ' ' || coalesce(t.value, '') || ' ' || a.value || ' ' || c.value) AS value
FROM $_transactionsTable AS tr
LEFT JOIN (
	SELECT tt.transaction_id, GROUP_CONCAT(t.title, ' ') AS value
	FROM $_transactionTagsTable AS tt
	JOIN $_tagsTable AS t ON tt.tag_id = t.id
	GROUP BY tt.transaction_id
) AS t ON tr.id = t.transaction_id
LEFT JOIN (
	SELECT id, (title || ' ' || type || ' ' || currency_code) AS value
	FROM $_accountsTable
) AS a ON tr.account_id = a.id
LEFT JOIN (
	SELECT id, (icon || ' ' || title || ' ' || transaction_type) AS value
FROM $_categoriesTable
) AS c ON tr.category_id = c.id;
""");

    // create fts tables
    for (final table in _tables) {
      batch.execute("""
CREATE VIRTUAL TABLE IF NOT EXISTS ${table}_fts
USING FTS5(id UNINDEXED, value, TOKENIZE = 'trigram');
""");
    }

    // populate with data
    batch.execute("""
INSERT INTO ${_accountsTable}_fts(id, value)
SELECT id, (title || ' ' || type || ' ' || currency_code) AS value
FROM $_accountsTable;
""");
    batch.execute("""
INSERT INTO ${_categoriesTable}_fts(id, value)
SELECT id, (icon || ' ' || title || ' ' || transaction_type) AS value
FROM $_categoriesTable;
""");
    batch.execute("""
INSERT INTO ${_tagsTable}_fts(id, value)
SELECT id, title AS value
FROM $_tagsTable;
""");
    batch.execute("""
INSERT INTO ${_transactionsTable}_fts(id, value)
SELECT id, value
FROM $_transactionsToFtsView;
""");

    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    final batch = db.batch();

    for (final table in _tables) {
      batch.execute("DROP TABLE IF EXISTS ${table}_fts;");
    }

    batch.execute("DROP VIEW IF EXISTS $_transactionsToFtsView;");

    await batch.commit();
  }
}
