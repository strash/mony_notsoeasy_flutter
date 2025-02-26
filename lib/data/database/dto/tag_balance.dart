import "package:freezed_annotation/freezed_annotation.dart";

part "tag_balance.freezed.dart";
part "tag_balance.g.dart";

@freezed
abstract class TagBalanceDto with _$TagBalanceDto {
  const factory TagBalanceDto({
    required String id,
    required String created,
    required String totalAmount,
    required String? firstTransactionDate,
    required String? lastTransactionDate,
    required int transactionsCount,
  }) = _TagBalanceDto;

  factory TagBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$TagBalanceDtoFromJson(json);
}
