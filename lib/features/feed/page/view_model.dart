import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:mony_app/features/feed/page/view.dart";
import "package:mony_app/features/navbar/page/page.dart";
import "package:rxdart/rxdart.dart";

export "../use_case/use_case.dart";
export "./event.dart";
export "./state.dart";

class FeedViewModelBuilder extends StatefulWidget {
  const FeedViewModelBuilder({super.key});

  @override
  ViewModelState<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  final subject = BehaviorSubject<FeedEvent>();

  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<FeedEvent> _feedSub;
  late final StreamSubscription<NavbarEvent> _navbarSub;

  final pageController = PageController();
  final List<ScrollController> scrollControllers = [];
  final List<double> scrollPositions = [];

  List<FeedPageState> pages = [];

  int get currentPageIndex {
    if (!pageController.isReady) return 0;
    return pageController.page?.toInt() ?? 0;
  }

  void addPageScroll(int index) {
    final scrollController = ScrollController();
    scrollController.addListener(_sclollListener(index));
    scrollControllers.add(scrollController);
    scrollPositions.add(.0);
  }

  void Function() _sclollListener(int pageIndex) {
    return () {
      if (!context.mounted) return;
      OnScroll().call(context, (viewModel: this, pageIndex: pageIndex));
    };
  }

  void _onAppEvent(Event e) {
    if (!context.mounted) return;
    OnAppStateChanged().call(context, (event: e, viewModel: this));
  }

  void _onNavBarEvent(NavbarEventScrollToTopRequested e) {
    if (!context.mounted) return;
    context
        .viewModel<NavbarViewModel>()
        .returnToTop(scrollControllers.elementAt(currentPageIndex));
  }

  void _onFeedEvent(FeedEventScrolledToBottom event) {
    if (!context.mounted) return;
    OnDataFetched()
        .call(context, (viewModel: this, pageIndex: event.pageIndex));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      // -> feed
      _feedSub = subject.whereType<FeedEventScrolledToBottom>().throttle((e) {
        return TimerStream<FeedEvent>(e, const Duration(milliseconds: 400));
      }).listen(_onFeedEvent);

      // -> app events
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      // -> navbar
      _navbarSub = context
          .viewModel<NavbarViewModel>()
          .subject
          .whereType<NavbarEventScrollToTopRequested>()
          .listen(_onNavBarEvent);

      // -> scroll controllers
      OnInitialDataFetched().call(context, this).then((_) {
        for (final (index, _) in pages.indexed) {
          addPageScroll(index);
        }
      });
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    _feedSub.cancel();
    _navbarSub.cancel();
    for (final (index, controller) in scrollControllers.indexed) {
      controller.removeListener(_sclollListener(index));
      controller.dispose();
    }
    pageController.dispose();
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<FeedViewModel>(
      viewModel: this,
      useCases: [
        () => OnPageChanged(),
        () => OnTransactionPressed(),
      ],
      child: const FeedView(),
    );
  }
}
