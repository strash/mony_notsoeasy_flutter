import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class ExpenseTagDatabaseRepository {
  const factory ExpenseTagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<ExpenseTagDto>> getAll({required String expenseId});

  Future<List<ExpenseTagDto>> getMany({
    required String expenseId,
    required int limit,
    required int offset,
  });

  Future<ExpenseTagDto?> getOne({required String id});

  Future<void> create({
    required String expenseId,
    required ExpenseTagDto dto,
  });

  Future<void> delete({required String id});
}

final class _Impl
    with DatabaseRepositoryMixin
    implements ExpenseTagDatabaseRepository {
  final AppDatabase database;

  String get table => "expense_tags";

  const _Impl({required this.database});

  @override
  Future<List<ExpenseTagDto>> getAll({required String expenseId}) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery(
        """
SELECT et.id, et.created, et.updated, et.tag_id, t.title
FROM $table AS et
JOIN tags AS t ON et.tag_id = t.id
WHERE et.expense_id = ?;
""",
        [expenseId],
      );
      return List.generate(
        maps.length,
        (index) => ExpenseTagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<List<ExpenseTagDto>> getMany({
    required String expenseId,
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
WHERE et.expense_id = ? LIMIT ? OFFSET ?;
""",
        [expenseId, limit, offset],
      );
      return List.generate(
        maps.length,
        (index) => ExpenseTagDto.fromJson(maps.elementAt(index)),
        growable: false,
      );
    });
  }

  @override
  Future<ExpenseTagDto?> getOne({required String id}) async {
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
      return ExpenseTagDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({
    required String expenseId,
    required ExpenseTagDto dto,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final map = dto.toJson()..remove("title");
      map["expense_id"] = expenseId;
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
