import "package:flutter/widgets.dart";

abstract base class UseCase<T, V> {
  const UseCase();

  T call(BuildContext context, [V? value]);
}
