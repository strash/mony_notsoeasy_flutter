import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TransactionDatabaseRepository {
  const factory TransactionDatabaseRepository({required AppDatabase database}) =
      _Impl;

  Future<List<TransactionDto>> search({
    String? query,
    required int limit,
    required int offset,
  });

  Future<int> count();

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

  /// Retrieves a list of transactions that occurred between two dates.
  ///
  /// The `from` date is inclusive, while the `to` date is exclusive.
  /// This means that if `from` is set to "2024-01-02T10:11:12.123Z" and `to` is
  /// set to "2024-01-03T10:11:12.123Z", the returned list will include
  /// transactions that occurred on "2024-01-02" only, and will not include
  /// any transactions from "2024-01-03".
  ///
  /// - Parameters:
  ///   - `from`: inclusive.
  ///   - `to`: exclusive.
  Future<List<TransactionDto>> getRange({
    required String from,
    required String to,
    required String accountId,
    required String transactionType,
  });

  Future<TransactionDto?> getOne({required String id});

  Future<void> create({required TransactionDto dto});

  Future<void> update({required TransactionDto dto});

  Future<void> delete({required String id});

  Future<void> purge();

  Future<List<Map<String, dynamic>>> dump();
}

final class _Impl
    with DatabaseRepositoryMixin
    implements TransactionDatabaseRepository {
  final AppDatabase database;

  String get table => "transactions";

  const _Impl({required this.database});

  @override
  Future<List<TransactionDto>> search({
    String? query,
    required int limit,
    required int offset,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final List<String?> args = [];
      final hasQuery = query != null && query.isNotEmpty;
      if (hasQuery) args.add(queryToGlob(query));
      final maps = await db.rawQuery("""
SELECT tr.* FROM ${table}_fzf_view AS tr_v
LEFT JOIN $table AS tr ON tr_v.id = tr.id
${hasQuery ? "WHERE tr_v.value GLOB ?" : ""}
GROUP BY tr_v.value
ORDER BY
	tr.date DESC,
	tr.updated DESC
LIMIT $limit OFFSET $offset;
""", args);
      return maps.map(TransactionDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<int> count() async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery("SELECT COUNT(*) AS count FROM $table;");
      if (maps.isEmpty) return 0;
      return maps[0]["count"] as int? ?? 0;
    });
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
      final maps = await db.rawQuery("""
SELECT tr.* FROM $table AS tr
LEFT JOIN transaction_tags AS tt ON tr.id = tt.transaction_id
${where.$1}
GROUP BY tr.id
ORDER BY tr.date DESC;
""", where.$2);
      return maps.map(TransactionDto.fromJson).toList(growable: false);
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
      final maps = await db.rawQuery("""
SELECT tr.* FROM $table AS tr
LEFT JOIN transaction_tags AS tt ON tr.id = tt.transaction_id
${where.$1}
GROUP BY tr.id
ORDER BY tr.date DESC
LIMIT $limit
OFFSET $offset;
""", where.$2);
      return maps.map(TransactionDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<List<TransactionDto>> getRange({
    required String from,
    required String to,
    required String accountId,
    required String transactionType,
  }) async {
    return resolve(() async {
      final db = await database.db;
      String where = "";
      final List<Object?> args = [from, to];
      if (accountId.isNotEmpty) {
        where = "AND tr.account_id = ?";
        args.add(accountId);
      }
      if (transactionType.isNotEmpty) {
        where = "$where AND c.transaction_type = ?";
        args.add(transactionType);
      }

      final maps = await db.rawQuery("""
SELECT tr.* FROM $table AS tr
LEFT JOIN categories AS c ON tr.category_id = c.id
WHERE tr.date BETWEEN ? AND ? $where
ORDER BY tr.date DESC;
""", args);
      return maps.map(TransactionDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<TransactionDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(table, where: "id = ?", whereArgs: [id]);
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
        conflictAlgorithm: ConflictAlgorithm.replace,
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
      await db.delete(table, where: "id = ?", whereArgs: [id]);
    });
  }

  @override
  Future<void> purge() async {
    return resolve(() async {
      final db = await database.db;
      await db.delete(table);
    });
  }

  @override
  Future<List<Map<String, dynamic>>> dump() async {
    return resolve(() async {
      final db = await database.db;
      return db.rawQuery("SELECT * FROM $table;");
    });
  }

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
}
