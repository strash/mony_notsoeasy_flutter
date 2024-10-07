import "package:freezed_annotation/freezed_annotation.dart";

part "expense_tag.freezed.dart";
part "expense_tag.g.dart";

@freezed
final class ExpenseTagDto with _$ExpenseTagDto {
  const factory ExpenseTagDto({
    required String id,
    required String created,
    required String updated,
    required String expenseId,
    required String tagId,
  }) = _ExpenseTagDto;

  factory ExpenseTagDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseTagDtoFromJson(json);
}
