part of "component.dart";

final class NamedColorPickerController extends ChangeNotifier {
  EColorName? _value;

  NamedColorPickerController(EColorName? color) : _value = color;

  EColorName? get value => _value;

  set value(EColorName? newValue) {
    _value = newValue;
    notifyListeners();
  }
}
