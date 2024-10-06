import "package:mony_app/data/database/database.dart";
import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/repository/repository.dart";
import "package:sqflite/sqflite.dart";

abstract base class ExpenseDatabaseRepository
    extends IDatabaseRepository<ExpenseDto> {
  const factory ExpenseDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;
}

final class _Impl
    with DatabaseRepositoryMixin
    implements ExpenseDatabaseRepository {
  final AppDatabase database;

  String get table => "expenses";

  const _Impl({required this.database});

  @override
  Future<List<ExpenseDto>?> getAll([
    String? where,
    List<String>? whereArgs,
  ]) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        orderBy: "date DESC",
        where: where,
        whereArgs: whereArgs,
      );
      return List.generate(
        maps.length,
        (index) => ExpenseDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<ExpenseDto>?> getMany(
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
        orderBy: "date DESC",
        where: where,
        whereArgs: whereArgs,
      );
      return List.generate(
        maps.length,
        (index) => ExpenseDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<ExpenseDto?> getOne(String id) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return ExpenseDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create(ExpenseDto dto) async {
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
  Future<void> update(ExpenseDto dto) async {
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
