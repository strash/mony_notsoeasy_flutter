import "package:mony_app/common/common.dart";

final class TagTitleValidator implements IInputValidator {
  final List<String> _titles;

  TagTitleValidator({required List<String> titles})
    : _titles = titles.map((e) => e.toLowerCase()).toList(growable: false);

  @override
  String? call(String? value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        _titles.contains(value.trim().toLowerCase())) {
      return "Тег с таким названием уже существует";
    }
    return null;
  }
}
