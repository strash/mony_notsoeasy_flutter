import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
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
  State<FeedViewModelBuilder> createState() => FeedViewModel();
}

final class FeedViewModel extends ViewModelState<FeedViewModelBuilder> {
  final subject = BehaviorSubject<FeedEvent>();

  final _fetchData = OnDataFetched();

  final pageController = PageController();
  final List<ScrollController> scrollControllers = [];
  final List<double> scrollPositions = [];

  List<FeedPageState> pages = [];

  int get currentPageIndex {
    if (!pageController.isReady) return 0;
    return pageController.page?.toInt() ?? 0;
  }

  @override
  void initState() {
    super.initState();

    final ctx = context;
    subject.whereType<FeedEventScrolledToBottom>().throttle((e) {
      return TimerStream<FeedEvent>(e, const Duration(milliseconds: 400));
    }).listen((e) {
      final value = (viewModel: this, pageIndex: e.pageIndex);
      if (ctx.mounted) _fetchData(ctx, value);
    });

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final navbar = context.viewModel<NavbarViewModel>();
      navbar.subject.whereType<NavbarEventScrollToTopRequested>().listen((e) {
        navbar.returnToTop(scrollControllers.elementAt(currentPageIndex));
      });

      OnInitialDataFetched().call(context, this).then((_) {
        for (final element in pages.indexed) {
          final scrollController = ScrollController();
          scrollController.addListener(() {
            if (!ctx.mounted) return;
            OnScroll().call(ctx, (viewModel: this, pageIndex: element.$1));
          });
          scrollControllers.add(scrollController);
          scrollPositions.add(.0);
        }
      });
    });
  }

  @override
  void dispose() {
    for (final e in scrollControllers) {
      e.dispose();
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
      ],
      child: const FeedView(),
    );
  }
}
