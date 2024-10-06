import "package:mony_app/data/database/database.dart";
import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/repository/repository.dart";
import "package:sqflite/sqflite.dart";

abstract base class TagDatabaseRepository extends IDatabaseRepository<TagDto> {
  const factory TagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;
}

final class _Impl
    with DatabaseRepositoryMixin
    implements TagDatabaseRepository {
  final AppDatabase database;

  String get table => "tags";

  const _Impl({required this.database});

  @override
  Future<List<TagDto>?> getAll([
    String? where,
    List<String>? whereArgs,
  ]) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        orderBy: "title ASC",
        where: where,
        whereArgs: whereArgs,
      );
      return List.generate(
        maps.length,
        (index) => TagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<TagDto>?> getMany(
    int limit,
    int offset, [
    String? where,
    List<String>? whereArgs,
  ]) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        orderBy: "title ASC",
        where: where,
        whereArgs: whereArgs,
      );
      return List.generate(
        maps.length,
        (index) => TagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<TagDto?> getOne(String id) async {
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
  Future<void> create(TagDto dto) async {
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
  Future<void> update(TagDto dto) async {
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
  Future<void> delete(String id) async {
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
