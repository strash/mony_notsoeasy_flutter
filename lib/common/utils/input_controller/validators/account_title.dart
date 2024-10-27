import "package:mony_app/common/utils/utils.dart";

final class AccountTitleValidator implements IInputValidator {
  final List<String> _titles;

  AccountTitleValidator({required List<String> titles})
      : _titles = titles.map((e) => e.toLowerCase()).toList(growable: false);

  @override
  String? call(String? value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        _titles.contains(value.trim().toLowerCase())) {
      return "Счет с таким названием и такого типа уже существует";
    }
    return null;
  }
}
