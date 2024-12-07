import "package:mony_app/app/app.dart";
import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class CategoryDatabaseFactoryImpl
    implements ICategoryDatabaseFactory<CategoryModel> {
  @override
  CategoryModel toModel(CategoryDto dto) {
    return CategoryModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      title: dto.title,
      icon: dto.icon,
      colorName: EColorName.from(dto.colorName),
      transactionType: ETransactionType.from(dto.transactionType),
    );
  }

  @override
  CategoryDto toDto(CategoryModel model) {
    return CategoryDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      title: model.title,
      icon: model.icon,
      colorName: model.colorName.name,
      transactionType: model.transactionType.value,
    );
  }
}
