part of "./component.dart";

final class ColorPickerController extends ChangeNotifier {
  Color? _value;

  Color? get value => _value;

  set value(Color? newValue) {
    _value = newValue;
    notifyListeners();
  }
}
