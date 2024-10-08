import "dart:math";

import "package:mony_app/data/database/migrations/migrations.dart";
import "package:sqflite/sqflite.dart";

final class MigrationService {
  final List<BaseMigration> _migrations = [
    M1728167641Init(),
    M1728413017SeedDefaultCategories(),
  ];

  BaseMigration? getFor(int oldVersion, int newVersion) {
    final isUp = oldVersion < newVersion;
    final index = min(0, isUp ? newVersion - 1 : newVersion);
    final migrations = _migrations.elementAtOrNull(index);
    if (migrations == null) {
      throw ArgumentError.value(
        migrations,
        "MIGRATION: No migrations for $index version were found",
      );
    }
    return migrations;
  }
}

abstract base class BaseMigration {
  late final defaultColumns = """
id      TEXT PRIMARY KEY NOT NULL,
created TEXT DEFAULT ''  NOT NULL,
updated TEXT DEFAULT ''  NOT NULL
""";

  /// Migrate UP
  Future<void> up(Database db);

  /// Migrate DOWN
  Future<void> down(Database db);
}
