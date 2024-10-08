import "dart:ui";

import "package:mony_app/data/database/dto/dto.dart";
import "package:mony_app/data/database/factories/factories.dart";
import "package:mony_app/domain/domain.dart";

final class CategoryDatabaseFactoryImpl
    implements ICategoryDatabaseFactory<CategoryModel> {
  @override
  CategoryModel from(CategoryDto dto) {
    return CategoryModel(
      id: dto.id,
      created: DateTime.tryParse(dto.created)?.toLocal() ?? DateTime.now(),
      updated: DateTime.tryParse(dto.updated)?.toLocal() ?? DateTime.now(),
      title: dto.title,
      icon: dto.icon,
      sort: dto.sort,
      color: Color(int.tryParse(dto.color) ?? 0xFFFFFFFF),
      expenseType: EExpenseType.from(dto.expenseType),
    );
  }

  @override
  CategoryDto to(CategoryModel model) {
    final String color = model.color.value.toRadixString(16).toUpperCase();
    return CategoryDto(
      id: model.id,
      created: model.created.toUtc().toIso8601String(),
      updated: model.updated.toUtc().toIso8601String(),
      title: model.title,
      icon: model.icon,
      sort: model.sort,
      color: "0x${color.padLeft(8, "0")}",
      expenseType: model.expenseType.value,
    );
  }
}
