import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category/page/view.dart";
import "package:mony_app/features/category/use_case/use_case.dart";

final class CategoryViewModelBuilder extends StatefulWidget {
  final CategoryModel category;

  const CategoryViewModelBuilder({
    super.key,
    required this.category,
  });

  @override
  ViewModelState<CategoryViewModelBuilder> createState() => CategoryViewModel();
}

final class CategoryViewModel extends ViewModelState<CategoryViewModelBuilder> {
  late final StreamSubscription<Event> _appSub;

  final prefix = StringEx.random(10);

  late final FeedScrollController _scrollController;
  ScrollController get controller => _scrollController.controller;

  late CategoryModel category = widget.category;

  CategoryBalanceModel? balance;
  List<TransactionModel> feed = [];
  int scrollPage = 0;
  bool canLoadMore = true;

  void _onFeedEvent(FeedScrollControllerEvent event) {
    if (!mounted) return;
    OnDataFetched().call(context, this);
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    _scrollController = FeedScrollController(onData: _onFeedEvent);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
      await OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<CategoryViewModel>(
      viewModel: this,
      useCases: [
        () => OnTransactionPressed(),
        () => OnEditPressed(),
        () => OnDeletePressed(),
      ],
      child: const CategoryView(),
    );
  }
}
