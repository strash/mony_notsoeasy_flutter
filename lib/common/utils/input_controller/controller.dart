import "package:flutter/widgets.dart";
import "package:mony_app/common/utils/input_controller/validators/validators.dart";

export "./validators/validators.dart";

enum EInputValidationStrategy { any, all }

final class InputController {
  final key = GlobalKey<FormFieldState>();
  final focus = FocusNode();
  final controller = TextEditingController();
  final EInputValidationStrategy validationStrategy;
  final List<IInputValidator> validators;

  String get text => controller.text;

  set text(String value) => controller.text = value;

  bool get isValid {
    return key.currentState?.validate() ?? false;
  }

  InputController({
    this.validators = const [],
    this.validationStrategy = EInputValidationStrategy.any,
  });

  void onTapOutside(PointerDownEvent event) {
    if (focus.hasFocus) {
      validator(text);
      focus.unfocus();
    }
  }

  String? validator(String? value) {
    return switch (validationStrategy) {
      EInputValidationStrategy.any => _anyStrategy(value),
      EInputValidationStrategy.all => _allStrategy(value),
    };
  }

  void dispose() {
    focus.dispose();
    controller.dispose();
  }

  String? _anyStrategy(String? value) {
    if (validators.isEmpty) return null;
    final List<String?> res = [];
    for (final item in validators) {
      res.add(item(value));
    }
    if (res.contains(null)) return null;
    return res.firstWhere((e) => e != null);
  }

  String? _allStrategy(String? value) {
    if (validators.isEmpty) return null;
    for (final item in validators) {
      final res = item(value);
      if (res != null) return res;
    }
    return null;
  }
}
