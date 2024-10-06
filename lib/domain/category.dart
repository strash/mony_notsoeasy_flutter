import "package:freezed_annotation/freezed_annotation.dart";

part "category.freezed.dart";

@freezed
final class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required String icon,
  }) = _CategoryModel;
}
