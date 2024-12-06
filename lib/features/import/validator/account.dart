import "package:mony_app/features/import/import.dart";

final class AccountValidator extends BaseValidator {
  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.account;
    try {
      for (final element in input) {
        final entry = element[key];
        if (entry == null && column.isRequired) {
          throw Exception("отсутствует обязательное значение");
        }
      }
      return ValidationResult.ok("${column.title} — OK");
    } catch (e) {
      return ValidationResult.error("${column.title} — $e.");
    }
  }
}
