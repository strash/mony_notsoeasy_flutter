import "package:freezed_annotation/freezed_annotation.dart";

part "expense_tag.freezed.dart";

@freezed
class ExpenseTagModel with _$ExpenseTagModel {
  const factory ExpenseTagModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String tagId,
    required String title,
  }) = _ExpenseTagModel;
}
