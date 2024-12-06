import "package:mony_app/common/utils/input_controller/validators/amount.dart"
    as input_validator;
import "package:mony_app/features/import/import.dart";

final class AmountValidator extends BaseValidator {
  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.amount;
    try {
      final amountValidator = input_validator.AmountValidator();
      for (final element in input) {
        final entry = element[key];
        if (entry == null && column.isRequired) {
          throw Exception("отсутствует обязательное значение");
        }
        final s = amountValidator(entry);
        if (s is String) throw Exception(s);
        final d = double.tryParse(entry ?? "a");
        if (d == null) throw Exception("не удалось распознать значение");
      }
      return ValidationResult.ok("${column.title} — OK");
    } on Exception catch (e) {
      return ValidationResult.error("${column.title} — $e.");
    }
  }
}
