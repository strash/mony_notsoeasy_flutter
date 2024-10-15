part of "./component.dart";

final class _ValueProvider extends InheritedWidget {
  final ColorPickerController controller;

  const _ValueProvider({
    required super.child,
    required this.controller,
  });

  static ColorPickerController? maybeOf<T>(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<_ValueProvider>();
    return p?.controller;
  }

  static ColorPickerController of(BuildContext context) {
    final result = maybeOf(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_ValueProvider oldWidget) {
    return controller.value != oldWidget.controller.value;
  }
}
