import "package:mony_app/features/import/page/enum.dart";
import "package:mony_app/features/import/validator/validator.dart";

final class TagValidator extends BaseValidator {
  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.tag;
    try {
      for (final element in input) {
        final entry = element[key];
        if (entry == null && column.isRequired) {
          throw Exception("отсутствует обязательное значение");
        }
      }
      return ValidationResult.ok("${column.title} — OK");
    } on Exception catch (e) {
      return ValidationResult.error("${column.title} — $e.");
    }
  }
}