import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/models/models.dart";

part "account.freezed.dart";

@freezed
final class AccountValueObject with _$AccountValueObject {
  const factory AccountValueObject.create({
    required String title,
    required EAccountType type,
    required String currencyCode,
  }) = _AccountValueObject;
}
