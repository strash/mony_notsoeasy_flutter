import "package:freezed_annotation/freezed_annotation.dart";

part "expense_tag.freezed.dart";
part "expense_tag.g.dart";

@freezed
final class ExpenseTagDto with _$ExpenseTagDto {
  const factory ExpenseTagDto({
    required String id,
    required String created,
    required String updated,
    // ignore: invalid_annotation_target
    @JsonKey(name: "expense") required String expenseId,
    // ignore: invalid_annotation_target
    @JsonKey(name: "tag") required String tagId,
  }) = _ExpenseTagDto;

  factory ExpenseTagDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTagDtoFromJson(json);
}
