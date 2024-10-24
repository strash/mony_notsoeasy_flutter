import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TransactionTagDatabaseRepository {
  const factory TransactionTagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TransactionTagDto>> getAll({required String transactionId});

  Future<List<TransactionTagDto>> getMany({
    required String transactionId,
    required int limit,
    required int offset,
  });

  Future<TransactionTagDto?> getOne({required String id});

  Future<void> create({
    required String transactionId,
    required TransactionTagDto dto,
  });

  Future<void> delete({required String id});
}

final class _Impl
    with DatabaseRepositoryMixin
    implements TransactionTagDatabaseRepository {
  final AppDatabase database;

  String get table => "transaction_tags";

  const _Impl({required this.database});

  @override
  Future<List<TransactionTagDto>> getAll({
    required String transactionId,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery(
        """
SELECT et.id, et.created, et.updated, et.tag_id, t.title
FROM $table AS et
JOIN tags AS t ON et.tag_id = t.id
WHERE et.transaction_id = ?;
""",
        [transactionId],
      );
      return List.generate(
        maps.length,
        (index) => TransactionTagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<TransactionTagDto>> getMany({
    required String transactionId,
    required int limit,
    required int offset,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery(
        """
SELECT et.id, et.created, et.updated, et.tag_id, t.title
FROM $table AS et
JOIN tags AS t ON et.tag_id = t.id
WHERE et.transaction_id = ? LIMIT ? OFFSET ?;
""",
        [transactionId, limit, offset],
      );
      return List.generate(
        maps.length,
        (index) => TransactionTagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<TransactionTagDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.rawQuery(
        """
SELECT et.id, et.created, et.updated, et.tag_id, t.title
FROM $table AS et
JOIN tags AS t ON et.tag_id = t.id
WHERE et.id = ? LIMIT 1;
""",
        [id],
      );
      if (map.isEmpty) return null;
      return TransactionTagDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({
    required String transactionId,
    required TransactionTagDto dto,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final map = dto.toJson()..remove("title");
      map["transaction_id"] = transactionId;
      await db.insert(
        table,
        map,
        conflictAlgorithm: ConflictAlgorithm.rollback,
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
