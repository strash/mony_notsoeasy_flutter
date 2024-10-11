import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class ExpenseDatabaseRepository {
  const factory ExpenseDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<ExpenseDto>> getAll();

  Future<List<ExpenseDto>> getMany({required int limit, required int offset});

  Future<ExpenseDto?> getOne({required String id});

  Future<void> create({required ExpenseDto dto});

  Future<void> update({required ExpenseDto dto});

  Future<void> delete({required String id});
}

final class _Impl
    with DatabaseRepositoryMixin
    implements ExpenseDatabaseRepository {
  final AppDatabase database;

  String get table => "expenses";

  const _Impl({required this.database});

  @override
  Future<List<ExpenseDto>> getAll() async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(table, orderBy: "date DESC");
      return List.generate(
        maps.length,
        (index) => ExpenseDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<ExpenseDto>> getMany({
    required int limit,
    required int offset,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        orderBy: "date DESC",
      );
      return List.generate(
        maps.length,
        (index) => ExpenseDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<ExpenseDto?> getOne({required String id}) async {
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
  Future<void> create({required ExpenseDto dto}) async {
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
  Future<void> update({required ExpenseDto dto}) async {
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
