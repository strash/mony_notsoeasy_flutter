import "package:flutter/foundation.dart";

final class SelectController<T> extends ChangeNotifier {
  T _value;

  SelectController(T value) : _value = value;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
