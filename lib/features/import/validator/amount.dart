import "package:mony_app/common/utils/input_controller/validators/amount.dart"
    as input_validator;
import "package:mony_app/features/import/import.dart";
import "package:mony_app/i18n/strings.g.dart";

final class AmountValidator extends BaseValidator {
  final Translations translations;

  AmountValidator(this.translations);

  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.amount;
    final title = translations.models.import.column_title(context: column);
    try {
      final amountValidator = input_validator.AmountValidator(
        translations: translations,
      );
      for (final element in input) {
        final entry = element[key];
        if (entry == null && column.isRequired) {
          throw Exception(
            translations
                .features
                .import
                .map_columns_validation
                .error_message
                .missing_value,
          );
        }
        final s = amountValidator(entry);
        if (s is String) throw Exception(s);
        final d = double.tryParse(entry ?? "a");
        if (d == null) {
          throw Exception(
            translations
                .features
                .import
                .map_columns_validation
                .error_message
                .unknown_value,
          );
        }
      }
      return ValidationResult.ok("$title — OK");
    } on Exception catch (e) {
      return ValidationResult.error("$title — $e.");
    }
  }
}
