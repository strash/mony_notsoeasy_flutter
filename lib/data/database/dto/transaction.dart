import "package:freezed_annotation/freezed_annotation.dart";

part "transaction.freezed.dart";
part "transaction.g.dart";

@freezed
abstract class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    required String created,
    required String updated,
    required num amount,
    required String date,
    required String note,
    required String accountId,
    required String categoryId,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);
}
