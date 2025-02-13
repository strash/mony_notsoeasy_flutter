export "./account.dart";
export "./amount.dart";
export "./category.dart";
export "./date.dart";
export "./note.dart";
export "./tag.dart";
export "./transaction_type.dart";

final class ValidationResult {
  final String? ok;
  final String? error;

  ValidationResult({required this.ok, required this.error});

  ValidationResult.ok(String message) : this(ok: message, error: null);

  ValidationResult.error(String message)
    : this(ok: null, error: message.replaceAll("Exception: ", ""));
}

abstract base class BaseValidator {
  ValidationResult validate(List<Map<String, String>> input, String key);
}
