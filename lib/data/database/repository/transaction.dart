import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TransactionDatabaseRepository {
  const factory TransactionDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TransactionDto>> getAll({
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
  });

  Future<List<TransactionDto>> getMany({
    required int limit,
    required int offset,
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
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

  (String, List<Object>?) _getWhere(
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
  ) {
    final List<String> where = [];
    final List<String> args = [];
    if (accountIds != null && accountIds.isNotEmpty) {
      where.add("tr.account_id in (${getInArguments(accountIds)})");
      args.addAll(accountIds);
    }
    if (categoryIds != null && categoryIds.isNotEmpty) {
      where.add("tr.category_id in (${getInArguments(categoryIds)})");
      args.addAll(categoryIds);
    }
    if (tagIds != null && tagIds.isNotEmpty) {
      where.add("tt.tag_id in (${getInArguments(tagIds)})");
      args.addAll(tagIds);
    }
    if (where.isEmpty) return ("", null);
    return ("WHERE ${where.join(" AND ")}", args);
  }

  @override
  Future<List<TransactionDto>> getAll({
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(accountIds, categoryIds, tagIds);
      final maps = await db.rawQuery(
        """
SELECT tr.*
FROM transactions AS tr
LEFT JOIN transaction_tags AS tt ON tr.id = tt.transaction_id
${where.$1}
GROUP BY tr.id
ORDER BY tr.date DESC;
""",
        where.$2,
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
    List<String>? accountIds,
    List<String>? categoryIds,
    List<String>? tagIds,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(accountIds, categoryIds, tagIds);
      final maps = await db.rawQuery(
        """
SELECT tr.*
FROM transactions AS tr
LEFT JOIN transaction_tags AS tt ON tr.id = tt.transaction_id
${where.$1}
GROUP BY tr.id
ORDER BY tr.date DESC
LIMIT $limit
OFFSET $offset;
""",
        where.$2,
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
