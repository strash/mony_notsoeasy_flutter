import "package:mony_app/domain/domain.dart";

final class CategoryVO {
  final String title;
  final String icon;
  final int sort;
  final String colorName;
  final ETransactionType transactionType;

  const CategoryVO({
    required this.title,
    required this.icon,
    required this.sort,
    required this.colorName,
    required this.transactionType,
  });
}

sealed class CategoryVariant {}

final class CategoryVariantVO extends CategoryVariant {
  final CategoryVO vo;

  CategoryVariantVO({required this.vo});
}

final class CategoryVariantModel extends CategoryVariant {
  final CategoryModel model;

  CategoryVariantModel({required this.model});
}
