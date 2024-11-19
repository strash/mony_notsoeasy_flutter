import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TagDatabaseRepository {
  const factory TagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TagDto>> getAllSortedBy({required String order});

  Future<List<TagDto>> getAllForTransaction({required String transactionId});

  Future<List<TagDto>> getAll({List<String>? ids});

  Future<List<TagDto>> getMany({
    required int limit,
    required int offset,
  });

  Future<TagDto?> getOne({required String id});

  Future<void> create({required TagDto dto});

  Future<void> update({required TagDto dto});

  Future<void> delete({required String id});
}

final class _Impl
    with DatabaseRepositoryMixin
    implements TagDatabaseRepository {
  final AppDatabase database;

  String get table => "tags";

  const _Impl({required this.database});

  String _getIn(List<String> items) {
    return List.filled(items.length, "?").join(", ");
  }

  (String?, List<Object>?) _getWhere(List<String>? ids) {
    if (ids == null) return (null, null);
    return ("id IN (${_getIn(ids)})", ids);
  }

  @override
  Future<List<TagDto>> getAllSortedBy({required String order}) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery("""
SELECT
	id, created, updated, title
FROM (
	SELECT
		t.*,
		c.transaction_type,
		MAX(tr.date) as date
	FROM $table AS t
	LEFT JOIN transaction_tags AS tt ON t.id = tt.tag_id
	LEFT JOIN transactions AS tr ON tt.transaction_id = tr.id
	LEFT JOIN categories AS c ON tr.category_id = c.id
	GROUP BY t.id
) ORDER BY
	transaction_type $order,
	date DESC;
""");
      return List.generate(
        maps.length,
        (index) => TagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<TagDto>> getAllForTransaction({
    required String transactionId,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery(
        """
SELECT t.* FROM transaction_tags AS tt
RIGHT JOIN tags AS t ON tt.tag_id = t.id
WHERE transaction_id = ?
ORDER BY tt.created ASC;
""",
        [transactionId],
      );
      return List.generate(
        maps.length,
        (index) => TagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<TagDto>> getAll({List<String>? ids}) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(ids);
      final maps = await db.query(
        table,
        orderBy: "title ASC",
        where: where.$1,
        whereArgs: where.$2,
      );
      return List.generate(
        maps.length,
        (index) => TagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<TagDto>> getMany({
    required int limit,
    required int offset,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        orderBy: "title ASC",
      );
      return List.generate(
        maps.length,
        (index) => TagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<TagDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return TagDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required TagDto dto}) async {
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
  Future<void> update({required TagDto dto}) async {
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
