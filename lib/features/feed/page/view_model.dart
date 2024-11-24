import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:mony_app/features/feed/page/view.dart";
import "package:mony_app/features/feed/use_case/use_case.dart";
import "package:mony_app/features/navbar/page/page.dart";

export "./state.dart";

class FeedViewModelBuilder extends StatefulWidget {
  const FeedViewModelBuilder({super.key});

  @override
  ViewModelState<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<NavBarEvent> _navbarSub;

  final pageController = PageController();
  final List<FeedScrollController> scrollControllers = [];

  List<FeedPageState> pages = [];

  int get currentPageIndex {
    if (!pageController.isReady) return 0;
    return pageController.page?.toInt() ?? 0;
  }

  void _onFeedEvent(FeedScrollControllerEvent event) {
    if (!mounted) return;
    OnDataFetched().call(context, this);
  }

  void addPageScroll(int pageIndex) {
    final scrollController = FeedScrollController(onData: _onFeedEvent);
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
        () => OnAccountPressed(),
        () => OnAddAccountPressed(),
        () => OnPageChanged(),
        () => OnTransactionPressed(),
      ],
      child: const FeedView(),
    );
  }
}
