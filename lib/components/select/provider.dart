part of "./component.dart";

final class _ValueProvider<T> extends InheritedWidget {
  final SelectController<T?> controller;

  const _ValueProvider({
    required super.child,
    required this.controller,
  });

  static SelectController<T?>? maybeOf<T>(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<_ValueProvider<T>>();
    return p?.controller;
  }

  static SelectController<T?> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_ValueProvider<T> oldWidget) {
    return controller.value != oldWidget.controller.value;
  }
}
