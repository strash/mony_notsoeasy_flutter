import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1733571197AddFuzzyViews extends BaseMigration {
  final _accountsTable = "accounts";
  final _categoriesTable = "categories";
  final _tagsTable = "tags";
  final _transactionsTable = "transactions";
  final _transactionTagsTable = "transaction_tags";

  final _accountsFzfView = "accounts_fzf_view";
  final _categoriesFzfView = "categories_fzf_view";
  final _tagsFzfView = "tags_fzf_view";
  final _transactionsFzfView = "transactions_fzf_view";

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();

    // accounts
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_accountsFzfView(id, value) AS
SELECT id, (title || ' ' || currency_code) AS value
FROM $_accountsTable;
""");

    // categories
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_categoriesFzfView(id, value) AS
SELECT id, (icon || ' ' || title) AS value
FROM $_categoriesTable;
""");

    // tags
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_tagsFzfView(id, value) AS
SELECT id, title AS value
FROM $_tagsTable;
""");

    // transactions
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_transactionsFzfView(id, value) AS
SELECT
	tr.id,
	(
		COALESCE((
			SELECT GROUP_CONCAT(t.title, ' ')
			FROM $_transactionTagsTable AS tt
			JOIN $_tagsTable AS t ON tt.tag_id = t.id
			WHERE tr.id = tt.transaction_id
			GROUP BY tt.transaction_id
		), '') || ' ' ||
		tr.note || ' ' ||
		tr.amount || ' ' ||
		(
			SELECT value
			FROM $_categoriesFzfView
			WHERE id = tr.category_id
		) || ' ' ||
		(
			SELECT value
			FROM $_accountsFzfView
			WHERE id = tr.account_id
		)
	) AS value
FROM $_transactionsTable AS tr;
""");

    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    final batch = db.batch();

    batch.execute("DROP VIEW IF EXISTS $_transactionsFzfView;");
    batch.execute("DROP VIEW IF EXISTS $_accountsFzfView;");
    batch.execute("DROP VIEW IF EXISTS $_categoriesFzfView;");
    batch.execute("DROP VIEW IF EXISTS $_tagsFzfView;");

    await batch.commit();
  }
}
