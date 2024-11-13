import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/services.dart";

// -> tags

sealed class TransactionFormTag {}

final class TransactionFormTagVO extends TransactionFormTag {
  final TagVO vo;

  TransactionFormTagVO(this.vo);
}

final class TransactionTagFormModel extends TransactionFormTag {
  final TagModel model;

  TransactionTagFormModel(this.model);
}

// -> transaction

final class TransactionFormVO {
  final double amout;
  final DateTime date;
  final String note;
  final String accountId;
  final String categoryId;
  final List<TransactionFormTag> tags;

  TransactionFormVO({
    required this.amout,
    required this.date,
    required this.note,
    required this.accountId,
    required this.categoryId,
    required this.tags,
  });

  TransactionVO toTransactionVO(List<TransactionTagVO> tags) {
    return TransactionVO(
      amout: amout,
      date: date,
      note: note,
      accountId: accountId,
      categoryId: categoryId,
      tags: tags,
    );
  }
}
