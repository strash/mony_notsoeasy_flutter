import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";

abstract base class ViewModelState<B extends StatefulWidget> extends State<B> {
  final List<UseCase Function()> _useCases = [];

  void setProtectedState(VoidCallback callback) {
    if (mounted) setState(() => callback());
  }

  Type call<Type extends UseCase>() {
    final useCase = _useCases.whereType<Type Function()>().firstOrNull;
    if (useCase == null) throw ArgumentError.value(context);
    return useCase();
  }
}

final class ViewModel<S extends ViewModelState> extends InheritedWidget {
  final S viewModel;

  ViewModel({
    super.key,
    required this.viewModel,
    List<UseCase Function()> useCases = const [],
    required super.child,
  }) {
    viewModel._useCases.addAll(useCases);
  }

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
