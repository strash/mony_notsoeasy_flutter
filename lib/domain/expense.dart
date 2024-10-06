import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/domain.dart";

part "expense.freezed.dart";

@freezed
final class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required num amout,
    required DateTime date,
    @Default("") String note,
    required AccountModel account,
    required CategoryModel category,
    required List<TagModel> tags,
  }) = _ExpenseModel;
}
