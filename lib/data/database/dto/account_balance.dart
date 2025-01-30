import "package:freezed_annotation/freezed_annotation.dart";

part "account_balance.freezed.dart";
part "account_balance.g.dart";

@freezed
class AccountBalanceDto with _$AccountBalanceDto {
  const factory AccountBalanceDto({
    required String id,
    required String created,
    required String currencyCode,
    required num balance,
    required num totalAmount,
    required num expenseAmount,
    required num incomeAmount,
    required int totalCount,
    required int expenseCount,
    required int incomeCount,
    required String? firstTransactionDate,
    required String? lastTransactionDate,
  }) = _AccountBalanceDto;

  factory AccountBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$AccountBalanceDtoFromJson(json);
}
