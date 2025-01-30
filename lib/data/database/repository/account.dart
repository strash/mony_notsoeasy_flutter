import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class AccountDatabaseRepository {
  const factory AccountDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<AccountDto>> search({
    String? query,
    required int limit,
    required int offset,
  });

  Future<int> count();

  Future<List<AccountBalanceDto>> getBalances();

  Future<AccountBalanceDto?> getBalance({required String id});

  Future<AccountBalanceDto?> getBalanceForDateRange({
    required String id,
    required String from,
    required String to,
  });

  Future<List<AccountDto>> getAll({String? type, List<String>? ids});

  Future<List<AccountDto>> getMany({
    String? type,
    required int limit,
    required int offset,
  });

  Future<AccountDto?> getOne({required String id});

  Future<void> create({required AccountDto dto});

  Future<void> update({required AccountDto dto});

  Future<void> delete({required String id});

  Future<void> purge();

  Future<List<Map<String, dynamic>>> dump();
}

final class _Impl
    with DatabaseRepositoryMixin
    implements AccountDatabaseRepository {
  final AppDatabase database;

  String get table => "accounts";
  String get balancesView => "account_balances_view";

  const _Impl({required this.database});

  @override
  Future<List<AccountDto>> search({
    String? query,
    required int limit,
    required int offset,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final List<String?> args = [];
      final hasQuery = query != null && query.isNotEmpty;
      if (hasQuery) args.add(queryToGlob(query));
      final maps = await db.rawQuery(
        """
SELECT id, created, updated, title, type, currency_code, color_name, balance
FROM (
	SELECT a.*, MAX(tr.date) AS date
	FROM ${table}_fzf_view AS a_v
	LEFT JOIN transactions AS tr ON a_v.id = tr.account_id
	LEFT JOIN $table AS a ON a_v.id = a.id
	${hasQuery ? "WHERE a_v.value GLOB ?" : ""}
	GROUP BY a_v.value
)
ORDER BY
	date DESC,
	updated DESC,
	title ASC
LIMIT $limit OFFSET $offset;
""",
        args,
      );
      return maps.map(AccountDto.fromJson).toList(growable: false);
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
  Future<List<AccountBalanceDto>> getBalances() async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(balancesView);
      return maps.map(AccountBalanceDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<AccountBalanceDto?> getBalance({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        balancesView,
        where: "id = ?",
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return AccountBalanceDto.fromJson(maps.first);
    });
  }

  @override
  Future<AccountBalanceDto?> getBalanceForDateRange({
    required String id,
    required String from,
    required String to,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.rawQuery(
        """
SELECT
	a.id,
	a.created,
	a.currency_code,
	a.balance,
	COALESCE(SUM(tr.amount), 0.0) AS total_amount,
	SUM(IIF(tr.amount < 0, tr.amount, 0)) AS expense_amount,
	SUM(IIF(tr.amount >= 0, tr.amount, 0)) AS income_amount,
	COALESCE(COUNT(tr.id),0) AS total_count,
	SUM(IIF(tr.amount < 0, 1, 0)) AS expense_count,
	SUM(IIF(tr.amount >= 0, 1, 0)) AS income_count,
	MIN(tr.date) AS first_transaction_date,
	MAX(tr.date) AS last_transaction_date
FROM $table AS a
LEFT JOIN transactions AS tr ON a.id = tr.account_id
WHERE a.id = ? AND tr.date BETWEEN ? AND ?
GROUP BY a.id;
""",
        [id, from, to],
      );
      if (maps.isEmpty) return null;
      return AccountBalanceDto.fromJson(maps.first);
    });
  }

  @override
  Future<List<AccountDto>> getAll({String? type, List<String>? ids}) async {
    return resolve(() async {
      final db = await database.db;
      final where = _getWhere(type, ids);
      final maps = await db.query(
        table,
        orderBy: "created ASC",
        where: where.$1,
        whereArgs: where.$2,
      );
      return maps.map(AccountDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<List<AccountDto>> getMany({
    String? type,
    required int limit,
    required int offset,
  }) async {
    return resolve(() async {
      final db = await database.db;
      final maps = await db.query(
        table,
        limit: limit,
        offset: offset,
        orderBy: "created ASC",
        where: type != null ? "type = ?" : null,
        whereArgs: type != null ? [type] : null,
      );
      return maps.map(AccountDto.fromJson).toList(growable: false);
    });
  }

  @override
  Future<AccountDto?> getOne({required String id}) async {
    return resolve(() async {
      final db = await database.db;
      final map = await db.query(
        table,
        where: "id = ?",
        whereArgs: [id],
      );
      if (map.isEmpty) return null;
      return AccountDto.fromJson(map.first);
    });
  }

  @override
  Future<void> create({required AccountDto dto}) async {
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
  Future<void> update({required AccountDto dto}) async {
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

  (String?, List<Object>?) _getWhere(String? type, List<String>? ids) {
    switch ((type, ids)) {
      case (final String a, final List<String> b):
        return ("type = ? AND id IN (${getInArguments(b)})", [a, ...b]);
      case (final String a, null):
        return ("type = ?", [a]);
      case (null, final List<String> b):
        return ("id IN (${getInArguments(b)})", b);
      default:
        return (null, null);
    }
  }
}
