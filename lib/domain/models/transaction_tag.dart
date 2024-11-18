import "package:freezed_annotation/freezed_annotation.dart";

part "transaction_tag.freezed.dart";

// FIXME: maybe fuck this model and also dto and VO?
@freezed
class TransactionTagModel with _$TransactionTagModel {
  const factory TransactionTagModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String transactionId,
    required String tagId,
  }) = _TransactionTagModel;
}
