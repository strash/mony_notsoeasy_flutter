import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";
import "package:sqflite/sqflite.dart";

mixin DatabaseRepositoryMixin {
  Future<T> resolve<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DatabaseException catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }

  String getInArguments(List<String> items) {
    return List.filled(items.length, "?").join(", ");
  }

  /// Преобразует запрос в GLOB паттерн:
  /// ```dart
  /// final query = "Парам";
  /// print(queryToGlob(query)); // *[пП][аА][рР][аА][мМ]*
  /// ```
  /// ---
  /// `NOTE:` LIKE не обращает внимание на регистр, НО только для ascii символов
  /// (латиница). LOWER(fzf_view.value) также не уменьшает кириллицу. Поэтому
  /// искать с помощью LIKE нельзя в нашем случае.
  String? queryToGlob(String? query) {
    if (query == null || query.characters.isEmpty) return null;
    final join = query.characters.fold<List<String>>([], (prev, curr) {
      return prev..addAll(["[", curr.toLowerCase(), curr.toUpperCase(), "]"]);
    }).join();
    return "*$join*";
  }
}
