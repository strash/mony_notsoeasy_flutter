part of "component.dart";

final class _NamedColorPickerValueProvider
    extends InheritedNotifier<NamedColorPickerController> {
  const _NamedColorPickerValueProvider({
    required super.child,
    required super.notifier,
  });

  static NamedColorPickerController? maybeOf<T>(BuildContext context) {
    final p =
        context
            .dependOnInheritedWidgetOfExactType<
              _NamedColorPickerValueProvider
            >();
    return p?.notifier!;
  }

  static NamedColorPickerController of(BuildContext context) {
    final result = maybeOf(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_NamedColorPickerValueProvider oldWidget) {
    return notifier!.value != oldWidget.notifier!.value;
  }
}
