part of "./select.dart";

final class SelectController<T> extends ChangeNotifier {
  T _value;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  SelectController(T value) : _value = value;
}
