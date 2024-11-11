import "package:mony_app/common/common.dart";

final class AmountValidator implements IInputValidator {
  final RegExp _regEx = RegExp(kAmountPattern);

  @override
  String? call(String? value) {
    if (value != null && value.trim().isNotEmpty && !_regEx.hasMatch(value)) {
      return 'Допустимый формат: "123.45" или "-0,12"';
    }
    return null;
  }
}
