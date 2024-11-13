import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/services.dart";

sealed class TransactionFormTag {}

final class TransactionFormTagVO extends TransactionFormTag {
  final TagVO vo;

  TransactionFormTagVO(this.vo);
}

final class TransactionTagFormModel extends TransactionFormTag {
  final TagModel model;

  TransactionTagFormModel(this.model);
}
