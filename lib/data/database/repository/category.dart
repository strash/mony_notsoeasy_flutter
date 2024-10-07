import "package:mony_app/data/database/database.dart";
import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/repository/repository.dart";
import "package:sqflite/sqflite.dart";

abstract base class CategoryDatabaseRepository
    extends IDatabaseRepository<CategoryDto> {
  const factory CategoryDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;
}

final class _Impl
    with DatabaseRepositoryMixin
    implements CategoryDatabaseRepository {
  final AppDatabase database;

  String get table => "categories";

  const _Impl({required this.database});

  @override
  Future<List<CategoryDto>> getAll([
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
        (index) => CategoryDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<CategoryDto>> getMany(
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
        (index) => CategoryDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<CategoryDto?> getOne(String id) async {
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
  Future<void> create(CategoryDto dto) async {
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
  Future<void> update(CategoryDto dto) async {
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
