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
  final currentDateTime = "strftime('%Y-%m-%d %H:%M:%fZ')";

  // TODO: устанавливать вручную это поля
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

  String createTrigger(String tableName) {
    return """
CREATE TRIGGER _${tableName}__update_updated_trgr
AFTER UPDATE ON $tableName
FOR EACH ROW
BEGIN
    UPDATE $tableName SET updated = $currentDateTime WHERE id = NEW.id;
END;
""";
  }

  Future<void> up(Database db, int oldVersion, int newVersion);

  Future<void> down(Database db, int oldVersion, int newVersion);
}
