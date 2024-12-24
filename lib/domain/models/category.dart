import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";

part "category.freezed.dart";

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required String icon,
    required EColorName colorName,
    required ETransactionType transactionType,
  }) = _CategoryModel;
}

extension CategoryModelEx on List<CategoryModel> {
  List<CategoryModel> merge(List<CategoryModel> other) {
    return List<CategoryModel>.from(
      where((e) => !other.any((i) => e.id == i.id)),
    )
      ..addAll(other)
      ..sort((a, b) => a.title.compareTo(b.title));
  }
}
