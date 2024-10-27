import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class AccountDatabaseRepository {
  const factory AccountDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<AccountDto>> getAll({String? type});

  Future<List<AccountDto>> getMany({
    String? type,
    required int limit,
    required int offset,
  });

  Future<AccountDto?> getOne({required String id});

  Future<void> create({required AccountDto dto});

  Future<void> update({required AccountDto dto});

  Future<void> delete({required String id});
}

final class _Impl
    with DatabaseRepositoryMixin
    implements AccountDatabaseRepository {
  final AppDatabase database;

  String get table => "accounts";

  const _Impl({required this.database});

  @override
  Future<List<AccountDto>> getAll({String? type}) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        orderBy: "title ASC",
        where: type != null ? "type = ?" : null,
        whereArgs: type != null ? [type] : null,
      );
      return List.generate(
        maps.length,
        (index) => AccountDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<AccountDto>> getMany({
    String? type,
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
        where: type != null ? "type = ?" : null,
        whereArgs: type != null ? [type] : null,
      );
      return List.generate(
        maps.length,
        (index) => AccountDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<AccountDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return AccountDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required AccountDto dto}) async {
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
  Future<void> update({required AccountDto dto}) async {
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
