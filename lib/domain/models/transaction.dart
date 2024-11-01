import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/domain.dart";

part "transaction.freezed.dart";

enum ETransactionType {
  expense(value: "expense"),
  income(value: "income"),
  ;

  final String value;

  const ETransactionType({required this.value});

  static ETransactionType get defaultValue => ETransactionType.expense;

  static ETransactionType from(String type) {
    return ETransactionType.values.where((e) => e.value == type).firstOrNull ??
        defaultValue;
  }
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required double amount,
    required DateTime date,
    required String note,
    required AccountModel account,
    required CategoryModel category,
    required List<TransactionTagModel> tags,
  }) = _TransactionModel;
}
