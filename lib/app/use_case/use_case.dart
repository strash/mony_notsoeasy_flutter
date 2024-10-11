import "package:flutter/widgets.dart";

abstract base class BaseUseCase<T> {
  const BaseUseCase();

  T action(BuildContext context);

  T call(BuildContext context) {
    if (!context.mounted) throw ArgumentError.value(context);
    return action(context);
  }
}

abstract base class BaseValueUseCase<V, T> extends BaseUseCase<T> {
  set value(V newValue);

  V get value;
}
