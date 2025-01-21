import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TransactionTagDatabaseRepository {
  const factory TransactionTagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TransactionTagDto>> getAll({required String transactionId});

  Future<TransactionTagDto?> getOne({required String id});

  Future<void> create({required TransactionTagDto dto});

  Future<void> delete({required String id});

  Future<void> purge();

  Future<List<Map<String, dynamic>>> dump();
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
      final maps = await db.query(
        table,
        where: "transaction_id = ?",
        whereArgs: [transactionId],
        orderBy: "created ASC",
      );
      return maps.map(TransactionTagDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<TransactionTagDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return TransactionTagDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required TransactionTagDto dto}) async {
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

  @override
  Future<void> purge() async {
    return resolve(() async {
      final db = await database.db;
      await db.delete(table);
    });
  }

  @override
  Future<List<Map<String, dynamic>>> dump() async {
    return resolve(() async {
      final db = await database.db;
      return db.rawQuery("SELECT * FROM $table;");
    });
  }
}
