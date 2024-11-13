import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/models/models.dart";

part "account.freezed.dart";

@freezed
class AccountVO with _$AccountVO {
  const factory AccountVO({
    required String title,
    required EAccountType type,
    required String currencyCode,
    required String colorName,
    required double balance,
  }) = _AccountVO;
}
