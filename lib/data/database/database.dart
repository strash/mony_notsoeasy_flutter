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

  int get schemaVersion {
    return int.parse(
      const String.fromEnvironment("MIGRATE_VERSION", defaultValue: "1"),
    );
  }

  String get dbName {
    return const String.fromEnvironment("DB_NAME", defaultValue: "my.db");
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = path.join(dbPath, dbName);
    return await openDatabase(
      pathToDatabase,
      version: schemaVersion,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
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
