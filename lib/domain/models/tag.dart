import "package:freezed_annotation/freezed_annotation.dart";

part "tag.freezed.dart";

@freezed
class TagModel with _$TagModel {
  const factory TagModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
  }) = _TagModel;
}

extension TagsModelEx on List<TagModel> {
  List<TagModel> merge(List<TagModel> other) {
    return List<TagModel>.from(
      where((e) => !other.any((i) => e.id == i.id)),
    )
      ..addAll(other)
      ..sort((a, b) => a.title.compareTo(b.title));
  }
}
