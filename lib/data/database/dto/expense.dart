import "package:freezed_annotation/freezed_annotation.dart";

part "expense.freezed.dart";
part "expense.g.dart";

@freezed
final class ExpenseDto with _$ExpenseDto {
  const factory ExpenseDto({
    required String id,
    required String created,
    required String updated,
    required num amout,
    required String date,
    required String note,
    required String accountId,
    required String categoryId,
  }) = _ExpenseDto;

  factory ExpenseDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDtoFromJson(json);
}
