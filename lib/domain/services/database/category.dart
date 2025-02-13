import "package:mony_app/data/database/repository/category.dart";
import "package:mony_app/domain/domain.dart";

final class DomainCategoryService extends BaseDatabaseService {
  final CategoryDatabaseRepository _categoryRepo;
  final CategoryDatabaseFactoryImpl _categoryFactory;
  final CategoryBalanceDatabaseFactoryImpl _categoryBalanceFactory;

  @override
  final int perPage = 40;

  DomainCategoryService({
    required CategoryDatabaseRepository categoryRepo,
    required CategoryDatabaseFactoryImpl categoryFactory,
    required CategoryBalanceDatabaseFactoryImpl categoryBalanceFactory,
  }) : _categoryRepo = categoryRepo,
       _categoryFactory = categoryFactory,
       _categoryBalanceFactory = categoryBalanceFactory;

  Future<List<CategoryModel>> search({String? query, required int page}) async {
    final dtos = await _categoryRepo.search(
      query: query,
      limit: perPage,
      offset: offset(page),
    );
    return dtos
        .map<CategoryModel>(_categoryFactory.toModel)
        .toList(growable: false);
  }

  Future<int> count() async {
    return await _categoryRepo.count();
  }

  Future<CategoryBalanceModel?> getBalance({required String id}) async {
    final dto = await _categoryRepo.getBalance(id: id);
    if (dto == null) return null;
    return _categoryBalanceFactory.toModel(dto);
  }

  Future<List<CategoryModel>> getAll({
    ETransactionType? transactionType,
  }) async {
    final dtos = await _categoryRepo.getAll(
      transactionType: transactionType?.value,
    );
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
    final model = _categoryFactory.fromVO(vo);
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

  Future<void> purgeData() async {
    await _categoryRepo.purge();
  }

  Future<void> createDefaultCategories() async {
    await _categoryRepo.createDefaultCategories();
  }

  Future<List<Map<String, dynamic>>> dumpData() async {
    return _categoryRepo.dump();
  }
}
