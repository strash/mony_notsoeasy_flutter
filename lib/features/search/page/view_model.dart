import "dart:math";

import "package:flutter/widgets.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/features/search/page/view.dart";

final class SearchViewModelBuilder extends StatefulWidget {
  final double distance;
  final Animation<double> animation;
  final AnimationStatusListener statusListener;

  const SearchViewModelBuilder({
    super.key,
    required this.distance,
    required this.animation,
    required this.statusListener,
  });

  @override
  ViewModelState<SearchViewModelBuilder> createState() => SearchViewModel();
}

final class SearchViewModel extends ViewModelState<SearchViewModelBuilder>
    with WidgetsBindingObserver {
  double get distance => widget.distance;
  Animation<double> get animation => widget.animation;
  late final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.fastOutSlowIn,
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
