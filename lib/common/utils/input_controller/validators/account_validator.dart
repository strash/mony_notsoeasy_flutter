import "package:mony_app/common/utils/utils.dart";

final class AccountValidator implements IInputValidator {
  final List<String> _usedValues;

  AccountValidator({required List<String> titles})
      : _usedValues =
            titles.map((e) => e.toLowerCase()).toList(growable: false);

  @override
  String? call(String? value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        _usedValues.contains(value.trim().toLowerCase())) {
      return "Счет с таким названием и такого типа уже существует";
    }
    return null;
  }
}
