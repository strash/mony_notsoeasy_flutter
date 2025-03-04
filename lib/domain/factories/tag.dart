import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class TagDatabaseFactoryImpl extends BaseDatabaseFactory
    implements ITagDatabaseFactory<TagModel> {
  @override
  TagModel toModel(TagDto dto) {
    return TagModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      title: dto.title,
    );
  }

  @override
  TagDto toDto(TagModel model) {
    return TagDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      title: model.title,
    );
  }

  TagModel fromVO(TagVO vo) {
    final defaultColumns = newDefaultColumns;
    return TagModel(
      id: vo.id ?? defaultColumns.id,
      created: vo.created ?? defaultColumns.now,
      updated: vo.updated ?? defaultColumns.now,
      title: vo.title,
    );
  }
}
