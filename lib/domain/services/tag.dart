import "package:mony_app/data/database/database.dart";
import "package:mony_app/domain/domain.dart";

final class DomainTagService extends BaseDomainService {
  final TagDatabaseRepository _tagRepo;
  final TagDatabaseFactoryImpl _tagFactory;

  @override
  int get perPage => 20;

  DomainTagService({
    required TagDatabaseRepository tagRepo,
    required TagDatabaseFactoryImpl tagFactory,
  })  : _tagRepo = tagRepo,
        _tagFactory = tagFactory;

  Future<List<TagModel>> getAll() async {
    final dtos = await _tagRepo.getAll();
    return dtos.map<TagModel>(_tagFactory.toModel).toList(growable: false);
  }

  Future<List<TagModel>> getMany({required int page}) async {
    final dtos = await _tagRepo.getMany(
      limit: perPage,
      offset: offset(page),
    );
    return dtos.map<TagModel>(_tagFactory.toModel).toList(growable: false);
  }

  Future<TagModel?> getOne({required String id}) async {
    final dto = await _tagRepo.getOne(id: id);
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
    await _tagRepo.update(dto: _tagFactory.toDto(model));
    return model;
  }

  Future<void> delete({required String id}) async {
    await _tagRepo.delete(id: id);
  }
}
