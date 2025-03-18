import "package:mony_app/features/import/import.dart";
import "package:mony_app/i18n/strings.g.dart";

final class AccountValidator extends BaseValidator {
  final Translations translations;

  AccountValidator(this.translations);

  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.account;
    final title = translations.models.import.column_title(context: column);
    try {
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
      }
      return ValidationResult.ok("$title — OK");
    } catch (e) {
      return ValidationResult.error("$title — $e.");
    }
  }
}
