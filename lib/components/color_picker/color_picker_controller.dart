part of "./color_picker.dart";

final class ColorPickerController extends ChangeNotifier {
  ColorPickerController(Color? color) : _value = color;

  Color? _value;

  Color? get value => _value;

  set value(Color? newValue) {
    _value = newValue;
    notifyListeners();
  }
}
