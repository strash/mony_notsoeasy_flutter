part of "component.dart";

final class _NamedColorPickerValueProvider extends InheritedWidget {
  final NamedColorPickerController controller;

  const _NamedColorPickerValueProvider({
    required super.child,
    required this.controller,
  });

  static NamedColorPickerController? maybeOf<T>(BuildContext context) {
    final p =
        context
            .dependOnInheritedWidgetOfExactType<
              _NamedColorPickerValueProvider
            >();
    return p?.controller;
  }

  static NamedColorPickerController of(BuildContext context) {
    final result = maybeOf(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_NamedColorPickerValueProvider oldWidget) {
    return controller.value != oldWidget.controller.value;
  }
}
