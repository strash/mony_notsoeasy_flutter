abstract class IDatabaseRepository<T> {
  const IDatabaseRepository();

  Future<List<T>> getAll([String? where, List<String>? whereArgs]);

  Future<List<T>> getMany(
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
