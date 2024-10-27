export "./account_validator.dart";
export "./amount.dart";

abstract interface class IInputValidator {
  String? call(String? value);
}
