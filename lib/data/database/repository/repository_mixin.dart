import "package:flutter/foundation.dart";
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
}
