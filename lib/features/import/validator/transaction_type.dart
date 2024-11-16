import "package:mony_app/features/import/page/model/enum.dart";
import "package:mony_app/features/import/validator/validator.dart";

final class TransactionTypeValidator extends BaseValidator {
  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.transactionType;
    try {
      final Set<String> values = {};
      for (final element in input) {
        final entry = element[key];
        if (entry == null && column.isRequired) {
          throw Exception("отсутствует обязательное значение");
        }
        if (entry == null) continue;
        values.add(entry);
      }
      if (values.length > 2) {
        throw Exception("должно быть не больше 2 вариантов");
      }
      return ValidationResult.ok("${column.title} — OK");
    } on Exception catch (e) {
      return ValidationResult.error("${column.title} — $e.");
    }
  }
}
