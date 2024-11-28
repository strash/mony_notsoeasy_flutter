import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";

sealed class TransactionTagVariant {}

final class TransactionTagVariantVO extends TransactionTagVariant {
  final TagVO vo;
  TransactionTagVariantVO(this.vo);
}

final class TransactionTagVariantModel extends TransactionTagVariant {
  final TagModel model;
  TransactionTagVariantModel(this.model);
}
