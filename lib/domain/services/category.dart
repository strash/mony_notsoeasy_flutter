import "package:mony_app/data/database/repository/category.dart";
import "package:mony_app/domain/domain.dart";

final class DomainCategoryService extends BaseDomainService {
  final CategoryDatabaseRepository _categoryRepo;
  final CategoryDatabaseFactoryImpl _categoryFactory;

  @override
  final int perPage = 20;

  DomainCategoryService({
    required CategoryDatabaseRepository categoryRepo,
    required CategoryDatabaseFactoryImpl categoryFactory,
  })  : _categoryRepo = categoryRepo,
        _categoryFactory = categoryFactory;

  Future<List<CategoryModel>> getAll({
    ETransactionType? transactionType,
  }) async {
    final dtos =
        await _categoryRepo.getAll(transactionType: transactionType?.value);
    return dtos
        .map<CategoryModel>(_categoryFactory.toModel)
        .toList(growable: false);
  }

  Future<List<CategoryModel>> getMany({
    required int page,
    ETransactionType? transactionType,
  }) async {
    final dtos = await _categoryRepo.getMany(
      limit: perPage,
      offset: offset(page),
      transactionType: transactionType?.value,
    );
    return dtos
        .map<CategoryModel>(_categoryFactory.toModel)
        .toList(growable: false);
  }

  Future<CategoryModel?> getOne({required String id}) async {
    final dto = await _categoryRepo.getOne(id: id);
    if (dto == null) return null;
    return _categoryFactory.toModel(dto);
  }

  Future<CategoryModel> create({required CategoryVO vo}) async {
    final CategoryVO(:title, :icon, :sort, :color, :transactionType) = vo;
    final defaultColumns = newDefaultColumns;
    final model = CategoryModel(
      id: defaultColumns.id,
      created: defaultColumns.now,
      updated: defaultColumns.now,
      title: title,
      icon: icon,
      sort: sort,
      color: color,
      transactionType: transactionType,
    );
    await _categoryRepo.create(dto: _categoryFactory.toDto(model));
    return model;
  }

  Future<CategoryModel> update({required CategoryModel model}) async {
    await _categoryRepo.update(
      dto: _categoryFactory.toDto(model.copyWith(updated: DateTime.now())),
    );
    return model;
  }

  Future<void> delete({required String id}) async {
    await _categoryRepo.delete(id: id);
  }
}