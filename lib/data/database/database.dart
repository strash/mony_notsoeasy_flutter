import "dart:io";

import "package:flutter/foundation.dart";
import "package:mony_app/common/constants.dart";
import "package:mony_app/data/database/migration_service.dart";
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";

export "./dto/dto.dart";
export "./factories/factories.dart";
export "./repository/repository.dart";

class AppDatabase {
  Future<Database>? _db;
  final _migrations = MigrationService();

  static final AppDatabase _instance = AppDatabase._();

  factory AppDatabase.instance() => _instance;

  AppDatabase._();

  Future<Database> get db {
    _db ??= _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    String dbPath = await getDatabasesPath();
    if (kDebugMode && !kIsDbOnDevice) {
      if (kDevPathToLocalDb.isNotEmpty) {
        final dir = Directory(kDevPathToLocalDb);
        final exists = await dir.exists();
        if (!exists) await dir.create(recursive: true);
        dbPath = dir.path;
      }
    }
    final pathToDatabase = path.join(dbPath, kDbName);
    return await openDatabase(
      pathToDatabase,
      version: kMigrateVersion,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
        await db.rawQuery("PRAGMA journal_mode = WAL");
        await db.execute("VACUUM;");
      },
      onCreate: (db, version) async {
        _migrations.getFor(0, version).forEach((e) async => await e.up(db));
      },
      onUpgrade: (db, from, to) async {
        _migrations.getFor(from, to).forEach((e) async => await e.up(db));
      },
      onDowngrade: (db, from, to) async {
        _migrations.getFor(from, to).forEach((e) async => await e.down(db));
      },
    );
  }
}
