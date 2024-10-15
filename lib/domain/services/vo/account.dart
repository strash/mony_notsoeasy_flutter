import "dart:ui";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/models/models.dart";

part "account.freezed.dart";

@freezed
sealed class AccountValueObject with _$AccountValueObject {
  const factory AccountValueObject.create({
    required String title,
    required EAccountType type,
    required String currencyCode,
    required Color color,
    @Default(0.0) double balance,
  }) = AccountCreateValueObject;

  const factory AccountValueObject.update({
    required AccountModel model,
    String? title,
    EAccountType? type,
    String? currencyCode,
    Color? color,
    double? balance,
  }) = AccountUpdateValueObject;
}
