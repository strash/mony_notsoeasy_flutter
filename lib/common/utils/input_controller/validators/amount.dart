import "package:mony_app/common/common.dart";
import "package:mony_app/i18n/strings.g.dart";

final class AmountValidator implements IInputValidator {
  final RegExp _regEx = RegExp(kAmountPattern);
  final Translations translations;

  AmountValidator({required this.translations});

  @override
  String? call(String? value) {
    if (value != null && value.trim().isNotEmpty && !_regEx.hasMatch(value)) {
      return translations.common.validator_message.amount;
    }
    return null;
  }
}
