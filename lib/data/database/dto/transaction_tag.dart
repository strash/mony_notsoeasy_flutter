import "package:freezed_annotation/freezed_annotation.dart";

part "transaction_tag.freezed.dart";
part "transaction_tag.g.dart";

@freezed
class TransactionTagDto with _$TransactionTagDto {
  const factory TransactionTagDto({
    required String id,
    required String created,
    required String updated,
    required String transactionId,
    required String tagId,
    required String title,
  }) = _TransactionTagDto;

  factory TransactionTagDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionTagDtoFromJson(json);
}