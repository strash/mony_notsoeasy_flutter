import "package:mony_app/data/database/migration_service.dart";
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";

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
        await _migrations.getFor(1)?.up(db, 0, 1);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _migrations.getFor(schemaVersion)?.up(db, oldVersion, newVersion);
      },
      onDowngrade: (db, oldVersion, newVersion) async {
        await _migrations
            .getFor(schemaVersion)
            ?.down(db, oldVersion, newVersion);
      },
    );
  }
}
