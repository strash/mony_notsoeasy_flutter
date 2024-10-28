import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/domain.dart";

part "transaction.freezed.dart";

@freezed
class TransactionVO with _$TransactionVO {
  const factory TransactionVO({
    required double amout,
    required ETransactionType type,
    required DateTime date,
    required String note,
    required String accountId,
    required String categoryId,
    required List<TransactionTagVO> tags,
  }) = _TransactionVO;
}
