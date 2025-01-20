import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class TagDatabaseRepository {
  const factory TagDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<TagDto>> search({
    String? query,
    required int limit,
    required int offset,
    List<String> excludeIds = const [],
  });

  Future<int> count();

  Future<TagBalanceDto?> getBalance({required String id});

  Future<List<TagDto>> getAll({
    List<String>? ids,
    String? transactionId,
  });

  Future<List<TagDto>> getMany({
    required int limit,
    required int offset,
  });

  Future<TagDto?> getOne({String? id, String? title});

  Future<void> create({required TagDto dto});

  Future<void> update({required TagDto dto});

  Future<void> delete({required String id});

  Future<void> purge();

  Future<List<Map<String, dynamic>>> dump();
}

final class _Impl
    with DatabaseRepositoryMixin
    implements TagDatabaseRepository {
  final AppDatabase database;

  String get table => "tags";
  String get balancesView => "tag_balances_view";

  const _Impl({required this.database});

  @override
  Future<List<TagDto>> search({
    String? query,
    required int limit,
    required int offset,
    List<String> excludeIds = const [],
  }) async {
    return resolve(() async {
      final db = await database.db;
      final List<String?> q = [];
      final List<Object?> args = [];
      if (query != null && query.isNotEmpty) {
        q.add("t_v.value GLOB ?");
        args.add(queryToGlob(query));
      }
      if (excludeIds.isNotEmpty) {
        q.add("t_v.id NOT IN (${getInArguments(excludeIds)})");
        args.addAll(excludeIds);
      }
      final maps = await db.rawQuery(
        """
SELECT id, created, updated, title
FROM (
	SELECT t.*, MAX(tr.date) AS date
	FROM ${table}_fzf_view AS t_v
	LEFT JOIN transaction_tags AS tt ON t_v.id = tt.tag_id
	LEFT JOIN transactions AS tr ON tt.transaction_id = tr.id
	LEFT JOIN $table AS t ON t_v.id = t.id
	${q.isNotEmpty ? "WHERE ${q.join(" AND ")}" : ""}
	GROUP BY t_v.value
)
ORDER BY
	date DESC,
	updated DESC,
	title ASC
LIMIT $limit OFFSET $offset;
""",
        args,
      );
      return maps.map(TagDto.fromJson).toList(growable: false);
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
  Future<TagBalanceDto?> getBalance({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        balancesView,
        where: "id = ?",
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return TagBalanceDto.fromJson(maps.first);
    });
  }

  @override
  Future<List<TagDto>> getAll({
    List<String>? ids,
    String? transactionId,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(ids: ids, transactionId: transactionId);
      final List<Map<String, Object?>> maps;
      if (transactionId != null) {
        // NOTE: we need to sort here by `created` because of transactions
        maps = await db.rawQuery(
          """
SELECT t.* FROM transaction_tags AS tt
RIGHT JOIN $table AS t ON tt.tag_id = t.id
WHERE ${where?.$1}
ORDER BY tt.created ASC;
""",
          where?.$2,
        );
      } else {
        final q = where != null ? "WHERE ${where.$1}" : "";
        maps = await db.rawQuery(
          "SELECT t.* FROM $table AS t $q ORDER BY t.title ASC;",
          where?.$2,
        );
      }
      return maps.map(TagDto.fromJson).toList(growable: false);
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
      return maps.map(TagDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<TagDto?> getOne({String? id, String? title}) async {
    assert(id != null || title != null);
    return resolve(() async {
      final db = await database.db;
      final where = switch ((id, title)) {
        (final String id, final String title) => (
            "id = ? AND title = ?",
            [id, title]
          ),
        (final String id, null) => ("id = ?", [id]),
        (null, final String title) => ("title = ?", [title]),
        (null, null) => throw UnimplementedError(),
      };
      final map = await db.query(
        table,
        where: where.$1,
        whereArgs: where.$2,
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

  (String?, List<Object>?)? _getWhere({
    List<String>? ids,
    String? transactionId,
  }) {
    final List<String> query = [];
    final List<Object> args = [];
    if (ids != null) {
      query.add("t.id IN (${getInArguments(ids)})");
      args.addAll(ids);
    }
    if (transactionId != null) {
      query.add("tt.transaction_id = ?");
      args.add(transactionId);
    }
    if (query.isEmpty) return null;
    return (query.join(" AND "), args);
  }
}
