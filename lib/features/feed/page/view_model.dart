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
  late final StreamSubscription<NavBarEvent> _navbarSub;

  final pageController = PageController();
  final List<ScrollController> scrollControllers = [];
  final List<double> scrollPositions = [];

  List<FeedPageState> pages = [];

  int get currentPageIndex {
    if (!pageController.isReady) return 0;
    return pageController.page?.toInt() ?? 0;
  }

  void addPageScroll(int pageIndex) {
    final scrollController = ScrollController();
    scrollController.addListener(_sclollListener(pageIndex));
    scrollControllers.add(scrollController);
    scrollPositions.add(.0);
  }

  Future<void> openPage(int pageIndex) async {
    _pagingToStart = true;
    await pageController.animateToPage(
      pageIndex,
      duration: Durations.long2,
      curve: Curves.easeInOut,
    );
    _pagingToStart = false;
  }

  void Function() _sclollListener(int pageIndex) {
    return () {
      if (!context.mounted) return;
      OnScroll().call(context, (viewModel: this, pageIndex: pageIndex));
    };
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    final value = (event: event, viewModel: this);
    OnFeedAppStateChanged().call(context, value);
  }

  bool _pagingToStart = false;

  void _onNavBarEvent(NavBarEvent e) {
    if (!context.mounted) return;
    switch (e) {
      case NavBarEventTabChanged():
        break;
      case NavBarEventScrollToTopRequested():
        final controller = scrollControllers.elementAt(currentPageIndex);
        // -> scroll to top
        if (controller.isReady && controller.position.pixels > .0) {
          context.viewModel<NavBarViewModel>().returnToTop(controller);
          // -> open first page
        } else {
          if (currentPageIndex == 0 || _pagingToStart) return;
          openPage(0);
        }
      case NavBarEventAddTransactionPreseed():
        OnNavbarAddTransactionPressed().call(context, this);
    }
  }

  void _onFeedEvent(FeedEventScrolledToBottom event) {
    if (!context.mounted) return;
    final value = (viewModel: this, pageIndex: event.pageIndex);
    OnDataFetched().call(context, value);
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
      _navbarSub =
          context.viewModel<NavBarViewModel>().subject.listen(_onNavBarEvent);

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
        () => OnAccountPressed(),
        () => OnAddAccountPressed(),
        () => OnPageChanged(),
        () => OnTransactionPressed(),
      ],
      child: const FeedView(),
    );
  }
}
