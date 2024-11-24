import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class CategoryDatabaseRepository {
  const factory CategoryDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;
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
}

final class _Impl
    with DatabaseRepositoryMixin
    implements CategoryDatabaseRepository {
  final AppDatabase database;

  String get table => "categories";

  const _Impl({required this.database});

  (String?, List<Object>?) _getWhere(String? type, List<String>? ids) {
    String getIn(List<String> items) {
      return List.filled(items.length, "?").join(", ");
    }

    switch ((type, ids)) {
      case (final String a, final List<String> b):
        return ("transaction_type = ? AND id IN (${getIn(b)})", [a, ...b]);
      case (final String a, null):
        return ("transaction_type = ?", [a]);
      case (null, final List<String> b):
        return ("id IN (${getIn(b)})", b);
      default:
        return (null, null);
    }
  }

  @override
  Future<CategoryBalanceDto?> getBalance({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.rawQuery(
        """
SELECT
	c.id,
	c.created,
	(
		SELECT JSON_GROUP_OBJECT(currency_code, total_amount)
		FROM
		(
			SELECT
				COALESCE(SUM(t.amount), 0) AS total_amount,
				a.currency_code
			FROM transactions AS t
			LEFT JOIN accounts AS a ON t.account_id = a.id
			WHERE t.category_id = ?1
			GROUP BY a.currency_code
		)
	) AS total_amount,
	MIN(t.date) AS first_transaction_date,
	MAX(t.date) AS last_transaction_date,
	COUNT(t.id) AS transactions_count
FROM transactions AS t
JOIN categories AS c ON t.category_id = c.id
WHERE c.id = ?1;
""",
        [id],
      );
      if (map.isEmpty) return null;
      return CategoryBalanceDto.fromJson(map.first);
    });
  }

  @override
  Future<List<CategoryDto>> getAll({
    String? transactionType,
    List<String>? ids,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(transactionType, ids);
      final maps = await db.query(
        table,
        where: where.$1,
        whereArgs: where.$2,
        orderBy: "sort ASC",
      );
      return List.generate(
        maps.length,
        (index) => CategoryDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<CategoryDto>> getMany({
    required int limit,
    required int offset,
    String? transactionType,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        where: transactionType != null ? "transaction_type = ?" : null,
        whereArgs: transactionType != null ? [transactionType] : null,
        orderBy: "sort ASC",
      );
      return List.generate(
        maps.length,
        (index) => CategoryDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<CategoryDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return CategoryDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required CategoryDto dto}) async {
    return resolve(() async {
      final db = await database.db;
      await db.insert(
        table,
        dto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    });
  }

  @override
  Future<void> update({required CategoryDto dto}) async {
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
  Future<void> delete({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      await db.delete(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
    });
  }
}
