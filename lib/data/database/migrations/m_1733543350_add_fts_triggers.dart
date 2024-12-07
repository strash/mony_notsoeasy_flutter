import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1733543350AddFtsTriggers extends BaseMigration {
  final _accountsTable = "accounts";
  final _categoriesTable = "categories";
  final _tagsTable = "tags";
  final _transactionsTable = "transactions";
  final _transactionsToFtsView = "_transactions_to_fts_view";

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();

    // accounts
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS insert_accounts_fts AFTER INSERT ON $_accountsTable
BEGIN
	INSERT INTO ${_accountsTable}_fts(id, value)
	VALUES (NEW.id, NEW.title || ' ' || NEW.type || ' ' || NEW.currency_code);
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS update_accounts_fts AFTER UPDATE ON $_accountsTable
BEGIN
	UPDATE ${_accountsTable}_fts
	SET value = NEW.title || ' ' || NEW.type || ' ' || NEW.currency_code
	WHERE id = NEW.id;
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS delete_accounts_fts AFTER DELETE ON $_accountsTable
BEGIN
	DELETE from ${_accountsTable}_fts WHERE id = OLD.id;
END;
""");

    // categories
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS insert_categories_fts AFTER INSERT ON $_categoriesTable
BEGIN
	INSERT INTO ${_categoriesTable}_fts(id, value)
	VALUES (NEW.id, NEW.icon || ' ' || NEW.title || ' ' || NEW.transaction_type);
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS update_categories_fts AFTER UPDATE ON $_categoriesTable
BEGIN
	UPDATE ${_categoriesTable}_fts
	SET value = NEW.icon || ' ' || NEW.title || ' ' || NEW.transaction_type
	WHERE id = NEW.id;
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS delete_categories_fts AFTER DELETE ON $_categoriesTable
BEGIN
	DELETE from ${_categoriesTable}_fts WHERE id = OLD.id;
END;
""");

    // tags
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS insert_tags_fts AFTER INSERT ON $_tagsTable
BEGIN
	INSERT INTO ${_tagsTable}_fts(id, value)
	VALUES (NEW.id, NEW.title);
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS update_tags_fts AFTER UPDATE ON $_tagsTable
BEGIN
	UPDATE ${_tagsTable}_fts
	SET value = NEW.title
	WHERE id = NEW.id;
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS delete_tags_fts AFTER DELETE ON $_tagsTable
BEGIN
	DELETE from ${_tagsTable}_fts WHERE id = OLD.id;
END;
""");

    // transactions
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS insert_transactions_fts AFTER INSERT ON $_transactionsTable
BEGIN
	INSERT INTO ${_transactionsTable}_fts(id, value)
	SELECT id, value FROM $_transactionsToFtsView
	WHERE id = NEW.id;
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS update_transactions_fts AFTER UPDATE ON $_transactionsTable
BEGIN
	UPDATE ${_transactionsTable}_fts
	SET value = (SELECT value FROM $_transactionsToFtsView WHERE id = NEW.id)
	WHERE id = NEW.id;
END;
""");
    batch.execute("""
CREATE TRIGGER IF NOT EXISTS delete_transactions_fts AFTER DELETE ON $_transactionsTable
BEGIN
	DELETE from ${_transactionsTable}_fts WHERE id = OLD.id;
END;
""");

    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    final batch = db.batch();

    // accounts
    batch.execute("DROP TRIGGER IF EXISTS insert_accounts_fts;");
    batch.execute("DROP TRIGGER IF EXISTS update_accounts_fts;");
    batch.execute("DROP TRIGGER IF EXISTS delete_accounts_fts;");

    // categories
    batch.execute("DROP TRIGGER IF EXISTS insert_categories_fts;");
    batch.execute("DROP TRIGGER IF EXISTS update_categories_fts;");
    batch.execute("DROP TRIGGER IF EXISTS delete_categories_fts;");

    // tags
    batch.execute("DROP TRIGGER IF EXISTS insert_tags_fts;");
    batch.execute("DROP TRIGGER IF EXISTS update_tags_fts;");
    batch.execute("DROP TRIGGER IF EXISTS delete_tags_fts;");

    // transactions
    batch.execute("DROP TRIGGER IF EXISTS insert_transactions_fts;");
    batch.execute("DROP TRIGGER IF EXISTS update_transactions_fts;");
    batch.execute("DROP TRIGGER IF EXISTS delete_transactions_fts;");

    await batch.commit();
  }
}
