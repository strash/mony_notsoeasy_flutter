import "dart:math";

import "package:flutter/foundation.dart";
import "package:mony_app/data/database/migrations/migrations.dart";
import "package:sqflite/sqflite.dart";

final class MigrationService {
  final List<BaseMigration> _migrations = [
    M1728167641Init(),
    M1728413017SeedDefaultCategories(),
    M1728991478AddColorAndBalanceColumnsToAccounts(),
    M1730475693RemoveTypeColumnFromTransactions(),
    M1733438092AddFullTextSearch(),
  ];

  Iterable<BaseMigration> getFor(int from, int to) {
    // NOTE: initial migration
    if (from == 0 && to == 1) return _migrations.take(1);
    final list = List<BaseMigration>.from(_migrations).toList(growable: false);
    final isUp = from < to;
    final (lhs, rhs) = (max(0, from), max(0, to));
    final begin = min(lhs, rhs);
    final range = (max(from, to) - min(from, to)).toInt();
    final migrations = list.skip(begin).take(range);
    final m = (isUp ? migrations : migrations.toList(growable: false).reversed);
    if (kDebugMode) {
      final fold = m.fold("\n", (prev, e) => "$prev\t -> ${e.runtimeType}\n");
      print("💿 MIGRATIONS: ${isUp ? "🆙" : "🔽"} from $from to $to: $fold");
    }
    return m;
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
