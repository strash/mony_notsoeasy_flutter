import "package:mony_app/data/database/migrations/migrations.dart";
import "package:sqflite/sqflite.dart";

final class MigrationService {
  final List<BaseMigration> _migrations = [
    M1728167641Init(),
  ];

  BaseMigration? getFor(int version) {
    if (version < 1) {
      throw ArgumentError.value(
        version,
        "MIGRATION: Version can't be less than 1",
      );
    }
    final migrations = _migrations.elementAtOrNull(version - 1);
    if (migrations == null) {
      throw ArgumentError.value(
        migrations,
        "MIGRATION: No migrations for $version version were found",
      );
    }
    return migrations;
  }
}

abstract base class BaseMigration {
  // TODO: устанавливать значения по-умолчанию для id, created и updated
  // для created, updated устанавливать DateTime.now().toUtc().toIso8601String()
  // а для id ExString.random(20)

  // TODO: а также обновлять updated при изменении строки
  late final defaultColumns = """
id      TEXT PRIMARY KEY NOT NULL,
created TEXT NOT NULL,
updated TEXT NOT NULL
""";

  String createIndex(
    String tableName,
    List<String> columns, [
    bool unique = true,
  ]) {
    if (columns.isEmpty) {
      throw ArgumentError.value(
        columns,
        "MIGRATION: Columns should contain at least one column",
      );
    }
    return """
CREATE ${unique ? "UNIQUE" : ""} INDEX _${tableName}__${columns.join("__")}_idx
ON $tableName (${columns.join(", ")});
""";
  }

  Future<void> up(Database db, int oldVersion, int newVersion);

  Future<void> down(Database db, int oldVersion, int newVersion);
}
