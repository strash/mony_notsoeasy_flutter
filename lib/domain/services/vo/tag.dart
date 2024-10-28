import "package:freezed_annotation/freezed_annotation.dart";

part "tag.freezed.dart";

@freezed
class TagVO with _$TagVO {
  const factory TagVO({
    required String title,
  }) = _TagVO;
}
