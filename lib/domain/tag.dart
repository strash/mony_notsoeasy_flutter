import "package:freezed_annotation/freezed_annotation.dart";

part "tag.freezed.dart";

@freezed
final class TagModel with _$TagModel {
  const factory TagModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
  }) = _TagModel;
}
