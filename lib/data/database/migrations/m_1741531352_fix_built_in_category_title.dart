import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1741531352FixBuiltInCategoryTitle extends BaseMigration {
  final _categories = "categories";

  @override
  Future<void> up(Database db) async {
    await db.execute(
      "UPDATE $_categories SET title = ?, updated = ? WHERE title = ?;",
      ["Инвестиции", DateTime.now().toUtc().toIso8601String(), "Инверстиции"],
    );
  }

  @override
  Future<void> down(Database db) async {}
}
