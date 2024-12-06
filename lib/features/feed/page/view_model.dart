import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/feed/feed.dart";
import "package:mony_app/features/feed/page/view.dart";
import "package:mony_app/features/feed/use_case/use_case.dart";
import "package:mony_app/features/navbar/navbar.dart";

export "./state.dart";

enum EFeedMenuItem { addAccount, addExpenseCategory, addIncomeCategory, addTag }

final class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  ViewModelState<FeedPage> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<NavBarEvent> _navbarSub;
  final _scrollBehavior = StreamController<double>.broadcast();

  Stream<double> get scrollDistanceStream => _scrollBehavior.stream;

  final pageController = PageController();
  final List<FeedScrollController> scrollControllers = [];

  List<FeedPageState> pages = [];

  int get currentPageIndex {
    if (!pageController.isReady) return 0;
    return pageController.page?.toInt() ?? 0;
  }

  void addPageScroll(int pageIndex) {
    final scrollController = FeedScrollController(onData: _onFeedEvent);
    scrollController.controller.addListener(_onScroll);
    scrollControllers.insert(pageIndex, scrollController);
  }

  void removePageScroll(int pageIndex) {
    scrollControllers.removeAt(pageIndex).dispose();
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

  void _onScroll() {
    final controller = scrollControllers.elementAtOrNull(currentPageIndex);
    if (controller != null && controller.isReady) {
      _scrollBehavior.add(controller.distance);
    }
  }

  void _onFeedEvent(FeedScrollControllerEvent event) {
    if (!mounted) return;
    OnDataFetched().call(context, this);
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
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
          context
              .viewModel<NavBarViewModel>()
              .returnToTop(controller.controller);
          // -> open first page
        } else {
          if (currentPageIndex == 0 || _pagingToStart) return;
          openPage(0);
        }
      case NavBarEventAddTransactionPreseed():
        OnNavbarAddTransactionPressed().call(context, this);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      // -> app events
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      // -> navbar
      _navbarSub =
          context.viewModel<NavBarViewModel>().subject.listen(_onNavBarEvent);

      // -> scroll controllers
      OnInit().call(context, this).then((_) {
        for (final (index, _) in pages.indexed) {
          addPageScroll(index);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollBehavior.close();
    _appSub.cancel();
    _navbarSub.cancel();
    for (final controller in scrollControllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<FeedViewModel>(
      viewModel: this,
      useCases: [
        () => OnSearchPressed(),
        () => OnMenuAddPressed(),
        () => OnAccountPressed(),
        () => OnPageChanged(),
        () => OnTransactionPressed(),
      ],
      child: const FeedView(),
    );
  }
}
