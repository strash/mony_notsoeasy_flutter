import "package:freezed_annotation/freezed_annotation.dart";

part "tag.freezed.dart";
part "tag.g.dart";

@freezed
final class TagDto with _$TagDto {
  const factory TagDto({
    required String id,
    required String created,
    required String updated,
    required String title,
  }) = _TagDto;

  factory TagDto.fromJson(Map<String, dynamic> json) => _$TagDtoFromJson(json);
}
