part of "./select.dart";

final class _SelectValueProvider<T>
    extends InheritedNotifier<SelectController<T?>> {
  const _SelectValueProvider({required super.child, required super.notifier});

  static SelectController<T?>? maybeOf<T>(BuildContext context) {
    final p =
        context.dependOnInheritedWidgetOfExactType<_SelectValueProvider<T>>();
    return p?.notifier!;
  }

  static SelectController<T?> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);
    if (result == null) throw ArgumentError.value(context);
    return result;
  }

  @override
  bool updateShouldNotify(_SelectValueProvider<T> oldWidget) {
    return notifier!.value != oldWidget.notifier!.value;
  }
}
