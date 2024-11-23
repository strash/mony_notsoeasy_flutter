import "package:freezed_annotation/freezed_annotation.dart";

part "category_balance.freezed.dart";
part "category_balance.g.dart";

@freezed
class CategoryBalanceDto with _$CategoryBalanceDto {
  const factory CategoryBalanceDto({
    required String id,
    required String created,
    required num totalSum,
    required String? firstTransactionDate,
    required String? lastTransactionDate,
    required int transactionsCount,
  }) = _CategoryBalanceDto;

  factory CategoryBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryBalanceDtoFromJson(json);
}
