import "package:freezed_annotation/freezed_annotation.dart";

part "transaction_tag.freezed.dart";

@freezed
class TransactionTagVO with _$TransactionTagVO {
  const factory TransactionTagVO({
    required String tagId,
    required String title,
  }) = _TransactionTagVO;
}
