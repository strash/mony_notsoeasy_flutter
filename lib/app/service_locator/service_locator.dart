import "package:flutter/widgets.dart";

final class ServiceLocator extends InheritedWidget {
  final List<Object Function()> _services = [];

  ServiceLocator({
    required List<Object Function()> services,
    required super.child,
  }) {
    _services.addAll(services);
  }

  static T? maybeOf<T>(BuildContext context) {
    final s = context.dependOnInheritedWidgetOfExactType<ServiceLocator>();
    final service = s?._services.whereType<T Function()>().firstOrNull;
    return service?.call();
  }

  static T of<T>(BuildContext context) {
    final s = maybeOf<T>(context);
    if (s == null) throw ArgumentError.value(context);
    return s;
  }

  @override
  bool updateShouldNotify(ServiceLocator oldWidget) {
    return false;
  }
}
