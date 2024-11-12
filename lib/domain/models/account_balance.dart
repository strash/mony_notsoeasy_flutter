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

extension AccountBalanceModelListEx on List<AccountBalanceModel> {
  List<AccountBalanceModel> merge(List<AccountBalanceModel> other) {
    return List<AccountBalanceModel>.from(where((e) => !other.contains(e)))
      ..addAll(other);
  }
}
