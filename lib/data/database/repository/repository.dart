import "package:flutter/foundation.dart";
import "package:sqflite/sqflite.dart";

export "./account.dart";
export "./category.dart";
export "./expense.dart";
export "./expense_tag.dart";
export "./tag.dart";

abstract class IDatabaseRepository<T> {
  const IDatabaseRepository();

  Future<List<T>?> getAll([String? where, List<String>? whereArgs]);

  Future<List<T>?> getMany(
    int limit,
    int offset, [
    String? where,
    List<String>? whereArgs,
  ]);

  Future<T?> getOne(String id);

  Future<void> create(T dto);

  Future<void> update(T dto);

  Future<void> delete(String id);
}

mixin DatabaseRepositoryMixin {
  Future<T> resolve<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DatabaseException catch (e) {
      if (kDebugMode) print(e);
      rethrow;
    }
  }
}
