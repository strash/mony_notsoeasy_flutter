import "package:freezed_annotation/freezed_annotation.dart";

part "transaction_tag.freezed.dart";

@freezed
class TransactionTagModel with _$TransactionTagModel {
  const factory TransactionTagModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String transactionId,
    required String tagId,
    required String title,
  }) = _TransactionTagModel;
}
