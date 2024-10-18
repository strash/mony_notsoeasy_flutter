import "package:flutter/widgets.dart";

abstract base class BaseUseCase<T> {
  const BaseUseCase();

  T action(BuildContext context);

  T call(BuildContext context) {
    if (!context.mounted) throw ArgumentError.value(context);
    return action(context);
  }
}

abstract base class BaseValueUseCase<V, T> {
  T action(BuildContext context, V value);

  T call(BuildContext context, V value) {
    if (!context.mounted) throw ArgumentError.value(context);
    return action(context, value);
  }
}
