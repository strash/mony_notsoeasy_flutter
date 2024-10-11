import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TagDatabaseRepository {
  const factory TagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TagDto>> getAll();

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

  @override
  Future<List<TagDto>> getAll() async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(table, orderBy: "title ASC");
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
