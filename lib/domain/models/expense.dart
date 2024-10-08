import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/models/models.dart";

part "expense.freezed.dart";

enum EExpenseType {
  expense(value: "expense"),
  income(value: "income"),
  ;

  final String value;

  const EExpenseType({required this.value});

  static EExpenseType get defaultValue => EExpenseType.expense;

  static EExpenseType from(String type) {
    return EExpenseType.values.where((e) => e.value == type).firstOrNull ??
        defaultValue;
  }
}

@freezed
class ExpenseModel with _$ExpenseModel {
  const factory ExpenseModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required double amout,
    required EExpenseType type,
    required DateTime date,
    required String note,
    required AccountModel account,
    required CategoryModel category,
    required List<TagModel> tags,
  }) = _ExpenseModel;
}
