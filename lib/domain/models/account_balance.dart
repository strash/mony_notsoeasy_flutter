import "package:freezed_annotation/freezed_annotation.dart";
import "package:sealed_currencies/sealed_currencies.dart";

part "account_balance.freezed.dart";

@freezed
class AccountBalanceModel with _$AccountBalanceModel {
  const factory AccountBalanceModel({
    required String id,
    required FiatCurrency currency,
    required double balance,
    required double totalAmount,
    required double totalSum,
  }) = _AccountBalanceModel;
}
