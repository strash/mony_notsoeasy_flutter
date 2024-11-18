import "package:freezed_annotation/freezed_annotation.dart";

part "transaction.freezed.dart";

@freezed
class TransactionVO with _$TransactionVO {
  const factory TransactionVO({
    required double amout,
    required DateTime date,
    required String note,
    required String accountId,
    required String categoryId,
    required List<String> tagIds,
  }) = _TransactionVO;
}
