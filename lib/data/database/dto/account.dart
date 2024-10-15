import "package:freezed_annotation/freezed_annotation.dart";

part "account.freezed.dart";
part "account.g.dart";

@freezed
class AccountDto with _$AccountDto {
  const factory AccountDto({
    required String id,
    required String created,
    required String updated,
    required String title,
    required String type,
    required String currencyCode,
    required String color,
    required num balance,
  }) = _AccountDto;

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
}
