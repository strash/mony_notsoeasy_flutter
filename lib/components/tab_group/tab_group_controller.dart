part of "./tab_group.dart";

final class TabGroupController<T> extends ChangeNotifier {
  T _value;

  TabGroupController(T value) : _value = value;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
