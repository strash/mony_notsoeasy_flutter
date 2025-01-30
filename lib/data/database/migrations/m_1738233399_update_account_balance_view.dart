import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1738233399UpdateAccountBalanceView extends BaseMigration {
  final _accountsTable = "accounts";
  final _transactionsTable = "transactions";

  final _accountBalancesView = "account_balances_view";

  @override
  Future<void> up(Database db) async {
    await db.execute("DROP VIEW IF EXISTS $_accountBalancesView;");
    await db.execute("""
CREATE VIEW IF NOT EXISTS $_accountBalancesView(
	id,
	created,
	currency_code,
	balance,
	total_amount,
	expense_amount,
	income_amount,
	total_count,
	expense_count,
	income_count,
	first_transaction_date,
	last_transaction_date
) AS
SELECT
	a.id,
	a.created,
	a.currency_code,
	a.balance,
	COALESCE(SUM(tr.amount), 0.0) AS total_amount,
	SUM(IIF(tr.amount < 0, tr.amount, 0)) AS expense_amount,
	SUM(IIF(tr.amount >= 0, tr.amount, 0)) AS income_amount,
	COALESCE(COUNT(tr.id),0) AS total_count,
	SUM(IIF(tr.amount < 0, 1, 0)) AS expense_count,
	SUM(IIF(tr.amount >= 0, 1, 0)) AS income_count,
	MIN(tr.date) AS first_transaction_date,
	MAX(tr.date) AS last_transaction_date
FROM $_accountsTable AS a
LEFT JOIN $_transactionsTable AS tr ON a.id = tr.account_id
GROUP BY a.id;
""");
  }

  @override
  Future<void> down(Database db) async {
    await db.execute("DROP VIEW IF EXISTS $_accountBalancesView;");
    await db.execute("""
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
  }
}
