import "package:mony_app/common/common.dart";
import "package:mony_app/i18n/strings.g.dart";

final class TagTitleValidator implements IInputValidator {
  final List<String> _titles;
  final Translations translations;

  TagTitleValidator({required List<String> titles, required this.translations})
    : _titles = titles.map((e) => e.toLowerCase()).toList(growable: false);

  @override
  String? call(String? value) {
    if (value != null &&
        value.trim().isNotEmpty &&
        _titles.contains(value.trim().toLowerCase())) {
      return translations.common.validator_message.tag;
    }
    return null;
  }
}
