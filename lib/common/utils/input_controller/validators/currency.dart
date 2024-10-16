import "package:mony_app/common/common.dart";

const _pattern =
    r"^-{0,1}0[.,][0-9]{1,2}$|^-{0,1}[1-9]?[0-9]*[.,]{0,1}[0-9]{1,2}$";

final class CurrencyValidator implements IInputValidator {
  final RegExp _regEx = RegExp(_pattern);

  @override
  String? call(String? value) {
    if (value != null && value.trim().isNotEmpty && !_regEx.hasMatch(value)) {
      return 'Допустимый формат: "123.45" или "-0,12"';
    }
    return null;
  }
}
