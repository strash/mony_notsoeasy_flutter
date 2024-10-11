import "package:flutter/widgets.dart";

abstract base class ViewModelState<B extends StatefulWidget> extends State<B> {
  void setProtectedState(VoidCallback callback) {
    if (mounted) setState(() => callback());
  }
}

final class ViewModel<S extends ViewModelState> extends InheritedWidget {
  final S viewModel;

  const ViewModel({
    super.key,
    required this.viewModel,
    required super.child,
  });

  static S? maybeOf<S extends ViewModelState>(BuildContext context) {
    final c = context.dependOnInheritedWidgetOfExactType<ViewModel<S>>();
    return c?.viewModel;
  }

  static S of<S extends ViewModelState>(BuildContext context) {
    final model = maybeOf<S>(context);
    if (model == null) throw ArgumentError.value(context);
    return model;
  }

  @override
  bool updateShouldNotify(ViewModel<S> oldWidget) {
    return true;
  }
}
