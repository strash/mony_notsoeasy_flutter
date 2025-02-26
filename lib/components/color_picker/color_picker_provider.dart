part of "./color_picker.dart";

final class _ColorPickerValueProvider
    extends InheritedNotifier<ColorPickerController> {
  const _ColorPickerValueProvider({
    required super.child,
    required super.notifier,
  });

  static ColorPickerController? maybeOf<T>(BuildContext context) {
    final p =
        context.dependOnInheritedWidgetOfExactType<_ColorPickerValueProvider>();
    return p?.notifier!;
  }

  static ColorPickerController of(BuildContext context) {
    final result = maybeOf(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_ColorPickerValueProvider oldWidget) {
    return notifier!.value != oldWidget.notifier!.value;
  }
}
