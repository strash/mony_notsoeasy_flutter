import "package:mony_app/domain/models/tag.dart";

final class TagVO {
  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final String title;

  const TagVO({
    this.id,
    this.created,
    this.updated,
    required this.title,
  });

  static TagVO? from(Map<String, dynamic> map) {
    final String? id = map["id"] as String?;
    final String? created = map["created"] as String?;
    final String? updated = map["updated"] as String?;
    final String? title = map["title"] as String?;

    if (id == null || title == null) return null;

    return TagVO(
      id: id,
      created: DateTime.tryParse(created ?? "")?.toLocal(),
      updated: DateTime.tryParse(updated ?? "")?.toLocal(),
      title: title,
    );
  }
}

sealed class TagVariant {}

final class TagVariantVO extends TagVariant {
  final TagVO vo;
  TagVariantVO(this.vo);
}

final class TagVariantModel extends TagVariant {
  final TagModel model;
  TagVariantModel(this.model);
}
