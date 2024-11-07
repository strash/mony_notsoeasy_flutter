import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/services.dart";

sealed class NewTransactionTag {}

final class NewTransactionTagVO extends NewTransactionTag {
  final TagVO vo;

  NewTransactionTagVO(this.vo);
}

final class NewTransactionTagModel extends NewTransactionTag {
  final TagModel model;

  NewTransactionTagModel(this.model);
}
