part of "component.dart";

final class ColorPickerController extends ChangeNotifier {
  EColorName? _value;

  EColorName? get value => _value;

  set value(EColorName? newValue) {
    _value = newValue;
    notifyListeners();
  }

  ColorPickerController(EColorName? color) : _value = color;
}
