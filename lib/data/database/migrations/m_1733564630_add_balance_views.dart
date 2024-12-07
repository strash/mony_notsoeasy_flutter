import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1733564630AddBalanceViews extends BaseMigration {
  final _accountsTable = "accounts";
  final _categoryTable = "categories";
  final _tagsTable = "tags";
  final _transactionsTable = "transactions";
  final _transactionTagsTable = "transaction_tags";

  final _accountBalancesView = "account_balances_view";
  final _categoryBalancesView = "category_balances_view";
  final _tagBalancesView = "tag_balances_view";

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();

    // accounts balances
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_accountBalancesView(
	id,
	created,
	currency_code,
	balance,
	total_amount,
	total_sum,
	first_transaction_date,
	last_transaction_date,
	transactions_count
) AS
SELECT
	a.id,
	a.created,
	a.currency_code,
	a.balance,
	COALESCE(SUM(tr.amount), 0.0) AS total_amount,
	(a.balance + COALESCE(SUM(tr.amount), 0.0)) AS total_sum,
	MIN(tr.date) AS first_transaction_date,
	MAX(tr.date) AS last_transaction_date,
	COALESCE(COUNT(tr.id), 0) AS transactions_count
FROM $_accountsTable AS a
LEFT JOIN $_transactionsTable AS tr ON a.id = tr.account_id
GROUP BY a.id;
""");

    // categories balances
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_categoryBalancesView(
	id,
	created,
	total_amount,
	first_transaction_date,
	last_transaction_date,
	transactions_count
) AS
SELECT
	c.id,
	c.created,
	(
		SELECT JSON_GROUP_OBJECT(currency_code, total_amount)
		FROM
		(
			SELECT
				a.currency_code,
				COALESCE(SUM(tr.amount), 0) AS total_amount
			FROM $_transactionsTable AS tr
			LEFT JOIN $_accountsTable AS a ON tr.account_id = a.id
			WHERE tr.category_id = c.id
			GROUP BY a.currency_code
		)
	) AS total_amount,
	MIN(tr.date) AS first_transaction_date,
	MAX(tr.date) AS last_transaction_date,
	COUNT(tr.id) AS transactions_count
FROM $_transactionsTable AS tr
RIGHT JOIN $_categoryTable AS c ON tr.category_id = c.id
GROUP BY c.id;
""");

    // tags balances
    batch.execute("""
CREATE VIEW IF NOT EXISTS $_tagBalancesView(
	id,
	created,
	total_amount,
	first_transaction_date,
	last_transaction_date,
	transactions_count
) AS
SELECT
	t.id,
	t.created,
	(
		SELECT JSON_GROUP_OBJECT(currency_code, total_amount)
		FROM
		(
			SELECT
				COALESCE(SUM(tr.amount), 0) AS total_amount,
				a.currency_code
			FROM $_transactionsTable AS tr
			LEFT JOIN $_accountsTable AS a ON tr.account_id = a.id
			LEFT JOIN $_transactionTagsTable AS tt ON tr.id = tt.transaction_id
			WHERE tt.tag_id = t.id
			GROUP BY a.currency_code
		)
	) AS total_amount,
	MIN(tr.date) AS first_transaction_date,
	MAX(tr.date) AS last_transaction_date,
	COUNT(tr.id) AS transactions_count
FROM $_transactionsTable AS tr
JOIN $_transactionTagsTable AS tt ON tr.id = tt.transaction_id
RIGHT JOIN $_tagsTable AS t ON tt.tag_id = t.id
GROUP BY t.id;
""");

    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    final batch = db.batch();

    batch.execute("DROP VIEW IF EXISTS $_accountBalancesView;");
    batch.execute("DROP VIEW IF EXISTS $_categoryBalancesView;");
    batch.execute("DROP VIEW IF EXISTS $_tagBalancesView;");

    await batch.commit();
  }
}
