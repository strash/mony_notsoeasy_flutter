import "dart:math";

import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/features/search/page/view.dart";

part "./route.dart";

final class SearchPage extends StatefulWidget {
  final double distance;
  final Animation<double> animation;
  final AnimationStatusListener statusListener;

  const SearchPage({
    super.key,
    required this.distance,
    required this.animation,
    required this.statusListener,
  });

  // TODO: возвращать вариант с разными моделями, чтобы в зависимости от модели
  // при закрытии этого экрана открывать экран модели (транзакция, тэг,
  // категория, счет) - Future<SearchVariant?>
  static Future<void> show(
    BuildContext context, {
    required double distance,
    required AnimationStatusListener statusListener,
  }) async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    return navigator.push<void>(
      _Route(
        builder: (context, animation) {
          return SearchPage(
            distance: distance,
            animation: animation,
            statusListener: statusListener,
          );
        },
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
      ),
    );
  }

  @override
  ViewModelState<SearchPage> createState() => SearchViewModel();
}

final class SearchViewModel extends ViewModelState<SearchPage>
    with WidgetsBindingObserver {
  double get distance => widget.distance;
  Animation<double> get animation => widget.animation;
  late final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.decelerate,
  );

  double keyboardHeight = .0;

  final input = InputController();

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setProtectedState(() {
      keyboardHeight = max(
        MediaQuery.of(context).viewInsets.bottom,
        MediaQuery.viewPaddingOf(context).bottom,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    animation.addStatusListener(widget.statusListener);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animation.removeStatusListener(widget.statusListener);
    curvedAnimation.dispose();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SearchViewModel>(
      viewModel: this,
      child: const SearchView(),
    );
  }
}
