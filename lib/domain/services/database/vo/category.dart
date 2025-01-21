import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/domain/domain.dart";

final class CategoryVO {
  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final String title;
  final String icon;
  final String colorName;
  final ETransactionType transactionType;

  const CategoryVO({
    this.id,
    this.created,
    this.updated,
    required this.title,
    required this.icon,
    required this.colorName,
    required this.transactionType,
  });

  static CategoryVO? from(Map<String, dynamic> map) {
    final String? id = map["id"] as String?;
    final String? created = map["created"] as String?;
    final String? updated = map["updated"] as String?;
    final String? title = map["title"] as String?;
    final String? icon = map["icon"] as String?;
    final String? colorName = map["color_name"] as String?;
    final String? transactionType = map["transaction_type"] as String?;

    if (id == null || title == null || icon == null) return null;

    return CategoryVO(
      id: id,
      created: DateTime.tryParse(created ?? "")?.toLocal(),
      updated: DateTime.tryParse(updated ?? "")?.toLocal(),
      title: title,
      icon: icon,
      colorName: EColorName.from(colorName ?? "").name,
      transactionType: ETransactionType.from(transactionType ?? ""),
    );
  }
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
