import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/features/search/page/view.dart";
import "package:mony_app/features/search/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

part "./enums.dart";
part "./route.dart";

final class SearchPage extends StatefulWidget {
  final Animation<double> animation;

  const SearchPage({
    super.key,
    required this.animation,
  });

  static void show(BuildContext context) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    navigator.push<void>(
      _Route(
        builder: (context, animation) {
          return SearchPage(animation: animation);
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

final class SearchViewModel extends ViewModelState<SearchPage> {
  late final StreamSubscription<Event> _appSub;

  final input = InputController();

  Animation<double> get animation => widget.animation;

  Map<ESearchPage, int> pageCounts = {
    for (final page in ESearchPage.values) page: 0,
  };

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SearchViewModel>(
      viewModel: this,
      useCases: [
        () => OnPagePressed(),
      ],
      child: Builder(
        builder: (context) {
          OnPageCountRequested().call(context);

          return const SearchView();
        },
      ),
    );
  }
}
