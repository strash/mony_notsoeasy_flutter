import "package:mony_app/data/database/database.dart";
import "package:mony_app/domain/domain.dart";

final class DomainTagService extends BaseDatabaseService {
  final TagDatabaseRepository _tagRepo;
  final TagDatabaseFactoryImpl _tagFactory;
  final TagBalanceDatabaseFactoryImpl _tagBalanceFactory;

  @override
  int get perPage => 40;

  DomainTagService({
    required TagDatabaseRepository tagRepo,
    required TagDatabaseFactoryImpl tagFactory,
    required TagBalanceDatabaseFactoryImpl tagBalanceFactory,
  })  : _tagRepo = tagRepo,
        _tagFactory = tagFactory,
        _tagBalanceFactory = tagBalanceFactory;

  Future<List<TagModel>> search({
    String? query,
    required int page,
    List<String> excludeIds = const [],
  }) async {
    final dtos = await _tagRepo.search(
      query: query,
      limit: perPage,
      offset: offset(page),
      excludeIds: excludeIds,
    );
    return dtos.map<TagModel>(_tagFactory.toModel).toList(growable: false);
  }

  Future<int> count() async {
    return await _tagRepo.count();
  }

  Future<TagBalanceModel?> getBalance({required String id}) async {
    final dto = await _tagRepo.getBalance(id: id);
    if (dto == null) return null;
    return _tagBalanceFactory.toModel(dto);
  }

  Future<List<TagModel>> getAll({List<String>? ids}) async {
    final dtos = await _tagRepo.getAll(ids: ids);
    return dtos.map<TagModel>(_tagFactory.toModel).toList(growable: false);
  }

  Future<List<TagModel>> getMany({required int page}) async {
    final dtos = await _tagRepo.getMany(
      limit: perPage,
      offset: offset(page),
    );
    return dtos.map<TagModel>(_tagFactory.toModel).toList(growable: false);
  }

  Future<TagModel?> getOne({String? id, String? title}) async {
    final dto = await _tagRepo.getOne(id: id, title: title);
    if (dto == null) return null;
    return _tagFactory.toModel(dto);
  }

  Future<TagModel> create({required TagVO vo}) async {
    final defaultColumns = newDefaultColumns;
    final model = TagModel(
      id: defaultColumns.id,
      created: defaultColumns.now,
      updated: defaultColumns.now,
      title: vo.title,
    );
    await _tagRepo.create(dto: _tagFactory.toDto(model));
    return model;
  }

  Future<TagModel> update({required TagModel model}) async {
    await _tagRepo.update(
      dto: _tagFactory.toDto(model.copyWith(updated: DateTime.now())),
    );
    return model;
  }

  Future<void> delete({required String id}) async {
    await _tagRepo.delete(id: id);
  }
}
