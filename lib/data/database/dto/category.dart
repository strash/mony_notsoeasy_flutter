import "package:freezed_annotation/freezed_annotation.dart";

part "category.freezed.dart";
part "category.g.dart";

@freezed
class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required String id,
    required String created,
    required String updated,
    required String title,
    required String icon,
    required int sort,
    required String expenseType,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
