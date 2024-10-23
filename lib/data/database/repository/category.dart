import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class CategoryDatabaseRepository {
  const factory CategoryDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;
  Future<List<CategoryDto>> getAll({String? expenseType});

  Future<List<CategoryDto>> getMany({
    required int limit,
    required int offset,
    String? expenseType,
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

  @override
  Future<List<CategoryDto>> getAll({String? expenseType}) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        where: expenseType != null ? "expense_type = ?" : null,
        whereArgs: expenseType != null ? [expenseType] : null,
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
    String? expenseType,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        where: expenseType != null ? "expense_type = ?" : null,
        whereArgs: expenseType != null ? [expenseType] : null,
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
