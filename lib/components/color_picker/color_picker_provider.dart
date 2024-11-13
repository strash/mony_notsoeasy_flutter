part of "./color_picker.dart";

final class _ColorPickerValueProvider extends InheritedWidget {
  final ColorPickerController controller;

  const _ColorPickerValueProvider({
    required super.child,
    required this.controller,
  });

  static ColorPickerController? maybeOf<T>(BuildContext context) {
    final p =
        context.dependOnInheritedWidgetOfExactType<_ColorPickerValueProvider>();
    return p?.controller;
  }

  static ColorPickerController of(BuildContext context) {
    final result = maybeOf(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_ColorPickerValueProvider oldWidget) {
    return controller.value != oldWidget.controller.value;
  }
}
