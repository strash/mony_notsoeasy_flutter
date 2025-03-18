import "package:mony_app/features/import/page/model/enum.dart";
import "package:mony_app/features/import/validator/validator.dart";
import "package:mony_app/i18n/strings.g.dart";

final class TransactionTypeValidator extends BaseValidator {
  final Translations translations;

  TransactionTypeValidator(this.translations);

  @override
  ValidationResult validate(List<Map<String, String>> input, String key) {
    const column = EImportColumn.transactionType;
    final title = translations.models.import.column_title(context: column);
    try {
      final Set<String> values = {};
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
        if (entry == null) continue;
        values.add(entry);
      }
      if (values.length > 2) {
        throw Exception(
          translations
              .features
              .import
              .map_columns_validation
              .error_message
              .only_two_options,
        );
      }
      return ValidationResult.ok("$title — OK");
    } on Exception catch (e) {
      return ValidationResult.error("$title — $e.");
    }
  }
}
