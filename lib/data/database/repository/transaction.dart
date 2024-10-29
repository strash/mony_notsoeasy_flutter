import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TransactionDatabaseRepository {
  const factory TransactionDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TransactionDto>> getAll({
    String? accountId,
    String? categoryId,
  });

  Future<List<TransactionDto>> getMany({
    required int limit,
    required int offset,
    String? accountId,
    String? categoryId,
  });

  Future<TransactionDto?> getOne({required String id});

  Future<void> create({required TransactionDto dto});

  Future<void> update({required TransactionDto dto});

  Future<void> delete({required String id});
}

final class _Impl
    with DatabaseRepositoryMixin
    implements TransactionDatabaseRepository {
  final AppDatabase database;

  String get table => "transactions";

  const _Impl({required this.database});

  (String?, List<Object>?) _getWhere(String? accountId, String? categoryId) {
    final (String? accountId, String? categoryId) input =
        (accountId, categoryId);
    switch (input) {
      case (final String a, final String b):
        return ("account_id = ? AND category_id = ?", [a, b]);
      case (final String a, null):
        return ("account_id = ?", [a]);
      case (null, final String b):
        return ("category_id = ?", [b]);
      default:
        return (null, null);
    }
  }

  @override
  Future<List<TransactionDto>> getAll({
    String? accountId,
    String? categoryId,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(accountId, categoryId);
      final maps = await db.query(
        table,
        orderBy: "date DESC",
        where: where.$1,
        whereArgs: where.$2,
      );
      return List.generate(
        maps.length,
        (index) => TransactionDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<TransactionDto>> getMany({
    required int limit,
    required int offset,
    String? accountId,
    String? categoryId,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(accountId, categoryId);
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        orderBy: "date DESC",
        where: where.$1,
        whereArgs: where.$2,
      );
      return List.generate(
        maps.length,
        (index) => TransactionDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<TransactionDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return TransactionDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required TransactionDto dto}) async {
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
  Future<void> update({required TransactionDto dto}) async {
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
