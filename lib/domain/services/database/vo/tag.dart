import "package:mony_app/domain/models/tag.dart";

final class TagVO {
  final String title;

  const TagVO({required this.title});
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
