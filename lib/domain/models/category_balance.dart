import "package:freezed_annotation/freezed_annotation.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "category_balance.freezed.dart";

@freezed
class CategoryBalanceModel with _$CategoryBalanceModel {
  const factory CategoryBalanceModel({
    required String id,
    required DateTime created,
    required int transactionsCount,
    required Map<FiatCurrency, double> totalAmount,
    required DateTime? firstTransactionDate,
    required DateTime? lastTransactionDate,
  }) = _CategoryBalanceModel;
}
