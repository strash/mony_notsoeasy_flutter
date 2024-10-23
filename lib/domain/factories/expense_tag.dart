import "package:mony_app/data/database/dto/expense_tag.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class ExpenseTagDatabaseFactoryImpl
    implements IExpenceTagDatabaseFactory<ExpenseTagModel> {
  @override
  ExpenseTagModel toModel(ExpenseTagDto dto) {
    return ExpenseTagModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      tagId: dto.tagId,
      title: dto.title,
    );
  }

  @override
  ExpenseTagDto toDto(ExpenseTagModel model) {
    return ExpenseTagDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      tagId: model.tagId,
      title: model.title,
    );
  }
}
