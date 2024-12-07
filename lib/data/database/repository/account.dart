import "package:mony_app/data/database/database.dart";
import "package:sqflite/sqflite.dart";

abstract base class AccountDatabaseRepository {
  const factory AccountDatabaseRepository({
    required AppDatabase database,
  }) = _Impl;

  Future<List<AccountBalanceDto>> getBalances();

  Future<AccountBalanceDto?> getBalance({required String id});

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
}

final class _Impl
    with DatabaseRepositoryMixin
    implements AccountDatabaseRepository {
  final AppDatabase database;

  String get table => "accounts";
  String get balancesView => "account_balances_view";

  const _Impl({required this.database});

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
        conflictAlgorithm: ConflictAlgorithm.rollback,
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
}
