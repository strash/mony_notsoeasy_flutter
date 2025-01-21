import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";

final class TransactionTagVO {
  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final String transactionId;
  final String tagId;

  TransactionTagVO({
    this.id,
    this.created,
    this.updated,
    required this.transactionId,
    required this.tagId,
  });

  static TransactionTagVO? from(Map<String, dynamic> map) {
    final String? id = map["id"] as String?;
    final String? created = map["created"] as String?;
    final String? updated = map["updated"] as String?;
    final String? transactionId = map["transaction_id"] as String?;
    final String? tagId = map["tag_id"] as String?;

    if (id == null || transactionId == null || tagId == null) return null;

    return TransactionTagVO(
      id: id,
      created: DateTime.tryParse(created ?? "")?.toLocal(),
      updated: DateTime.tryParse(updated ?? "")?.toLocal(),
      transactionId: transactionId,
      tagId: tagId,
    );
  }
}

sealed class TransactionTagVariant {}

final class TransactionTagVariantVO extends TransactionTagVariant {
  final TagVO vo;
  TransactionTagVariantVO(this.vo);
}

final class TransactionTagVariantModel extends TransactionTagVariant {
  final TagModel model;
  TransactionTagVariantModel(this.model);
}
