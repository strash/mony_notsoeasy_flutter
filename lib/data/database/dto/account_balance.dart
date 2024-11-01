import "package:freezed_annotation/freezed_annotation.dart";

part "account_balance.freezed.dart";
part "account_balance.g.dart";

@freezed
class AccountBalanceDto with _$AccountBalanceDto {
  const factory AccountBalanceDto({
    required String id,
    required String currencyCode,
    required num balance,
    required num totalAmount,
    required num totalSum,
  }) = _AccountBalanceDto;

  factory AccountBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$AccountBalanceDtoFromJson(json);
}
