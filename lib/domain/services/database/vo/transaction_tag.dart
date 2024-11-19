import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";

sealed class TransactionTagVO {}

final class TransactionTagVOVO extends TransactionTagVO {
  final TagVO vo;

  TransactionTagVOVO(this.vo);
}

final class TransactionTagVOModel extends TransactionTagVO {
  final TagModel model;

  TransactionTagVOModel(this.model);
}
