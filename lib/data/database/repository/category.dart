import "package:mony_app/data/database/database.dart";
import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

abstract base class CategoryDatabaseRepository {
  const factory CategoryDatabaseRepository({
    required AppDatabase database,
    required BaseMigration defaultCategoryMigration,
  }) = _Impl;

  Future<List<CategoryDto>> search({
    String? query,
    required int limit,
    required int offset,
  });

  Future<int> searchCount({String? query});

  Future<int> count();

  Future<CategoryBalanceDto?> getBalance({required String id});

  Future<List<CategoryDto>> getAll({
    String? transactionType,
    List<String>? ids,
  });

  Future<List<CategoryDto>> getMany({
    required int limit,
    required int offset,
    String? transactionType,
  });

  Future<CategoryDto?> getOne({required String id});

  Future<void> create({required CategoryDto dto});

  Future<void> update({required CategoryDto dto});

  Future<void> delete({required String id});

  Future<void> purge();

  Future<void> createDefaultCategories();

  Future<List<Map<String, dynamic>>> dump();
}

final class _Impl
    with DatabaseRepositoryMixin
    implements CategoryDatabaseRepository {
  final AppDatabase database;
  final BaseMigration migration;

  String get table => "categories";
  String get balancesView => "category_balances_view";

  const _Impl({
    required this.database,
    required BaseMigration defaultCategoryMigration,
  }) : migration = defaultCategoryMigration;

  @override
  Future<List<CategoryDto>> search({
    String? query,
    required int limit,
    required int offset,
  }) {
    return resolve(() async {
      final db = await database.db;
      final List<String?> args = [];
      final hasQuery = query != null && query.isNotEmpty;
      if (hasQuery) args.add(queryToGlob(query));
      final maps = await db.rawQuery("""
SELECT id, created, updated, title, icon, color_name, transaction_type
FROM (
	SELECT c.*, MAX(tr.date) AS date
	FROM ${table}_fzf_view AS c_v
	LEFT JOIN transactions AS tr ON c_v.id = tr.category_id
	LEFT JOIN $table AS c ON c_v.id = c.id
	${hasQuery ? "WHERE c_v.value GLOB ?" : ""}
	GROUP BY c_v.value
)
ORDER BY
	date DESC,
	updated DESC,
	title ASC
LIMIT $limit OFFSET $offset;
""", args);
      return maps.map(CategoryDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<int> searchCount({String? query}) {
    return resolve(() async {
      final db = await database.db;
      final List<String?> args = [];
      final hasQuery = query != null && query.isNotEmpty;
      if (hasQuery) args.add(queryToGlob(query));
      final maps = await db.rawQuery("""
SELECT COUNT(*) AS count FROM ${table}_fzf_view AS c_v
${hasQuery ? "WHERE c_v.value GLOB ?" : ""};
""", args);
      if (maps.isEmpty) return 0;
      return maps[0]["count"] as int? ?? 0;
    });
  }

  @override
  Future<int> count() {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery("SELECT COUNT(*) AS count FROM $table;");
      if (maps.isEmpty) return 0;
      return maps[0]["count"] as int? ?? 0;
    });
  }

  @override
  Future<CategoryBalanceDto?> getBalance({required String id}) {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        balancesView,
        where: "id = ?",
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return CategoryBalanceDto.fromJson(maps.first);
    });
  }

  @override
  Future<List<CategoryDto>> getAll({
    String? transactionType,
    List<String>? ids,
  }) {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(transactionType, ids);
      final maps = await db.query(
        table,
        where: where.$1,
        whereArgs: where.$2,
        orderBy: "transaction_type ASC, title ASC",
      );
      return maps.map(CategoryDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<List<CategoryDto>> getMany({
    required int limit,
    required int offset,
    String? transactionType,
  }) {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        where: transactionType != null ? "transaction_type = ?" : null,
        whereArgs: transactionType != null ? [transactionType] : null,
        orderBy: "transaction_type ASC, title ASC",
      );
      return maps.map(CategoryDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<CategoryDto?> getOne({required String id}) {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(table, where: "id = ?", whereArgs: [id]);
      if (map.isEmpty) return null;
      return CategoryDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required CategoryDto dto}) {
    return resolve(() async {
      final db = await database.db;
      await db.insert(
        table,
        dto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> update({required CategoryDto dto}) {
    return resolve(() async {
      final db = await database.db;
      await db.update(
        table,
        dto.toJson(),
        where: "id = ?",
        whereArgs: [dto.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> delete({required String id}) {
    return resolve(() async {
      final db = await database.db;
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    });
  }

  @override
  Future<void> purge() {
    return resolve(() async {
      final db = await database.db;
      await db.delete(table);
    });
  }

  @override
  Future<void> createDefaultCategories() async {
    final db = await database.db;
    await migration.up(db);
  }

  @override
  Future<List<Map<String, dynamic>>> dump() {
    return resolve(() async {
      final db = await database.db;
      return db.rawQuery("SELECT * FROM $table;");
    });
  }

  (String?, List<Object>?) _getWhere(String? type, List<String>? ids) {
    switch ((type, ids)) {
      case (final String a, final List<String> b):
        return (
          "transaction_type = ? AND id IN (${getInArguments(b)})",
          [a, ...b],
        );
      case (final String a, null):
        return ("transaction_type = ?", [a]);
      case (null, final List<String> b):
        return ("id IN (${getInArguments(b)})", b);
      default:
        return (null, null);
    }
  }
}
