import "package:freezed_annotation/freezed_annotation.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "tag_balance.freezed.dart";

@freezed
class TagBalanceModel with _$TagBalanceModel {
  const factory TagBalanceModel({
    required String id,
    required DateTime created,
    required int transactionsCount,
    required Map<FiatCurrency, double> totalAmount,
    required DateTime? firstTransactionDate,
    required DateTime? lastTransactionDate,
  }) = _TagBalanceModel;
}
