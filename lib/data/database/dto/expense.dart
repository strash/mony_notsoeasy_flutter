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
    @Default("") String note,
    // ignore: invalid_annotation_target
    @JsonKey(name: "account") required String accountId,
    // ignore: invalid_annotation_target
    @JsonKey(name: "category") required String categoryId,
  }) = _ExpenseDto;

  factory ExpenseDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDtoFromJson(json);
}
