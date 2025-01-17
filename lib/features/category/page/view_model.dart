import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category/page/view.dart";
import "package:mony_app/features/category/use_case/use_case.dart";
import "package:provider/provider.dart";

final class CategoryPage extends StatefulWidget {
  final CategoryModel category;

  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  ViewModelState<CategoryPage> createState() => CategoryViewModel();
}

final class CategoryViewModel extends ViewModelState<CategoryPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<FeedScrollControllerEvent> _scrollSub;

  final prefix = StringEx.random(10);

  final _scrollController = FeedScrollController();
  ScrollController get controller => _scrollController.controller;

  late CategoryModel category = widget.category;

  CategoryBalanceModel? balance;
  List<TransactionModel> feed = [];
  int scrollPage = 0;
  bool canLoadMore = true;

  bool isCentsVisible = true;
  bool isColorsVisible = true;
  bool isTagsVisible = true;

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
    _scrollSub = _scrollController.addListener(_onFeedEvent);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      final sharedPrefService = context.read<DomainSharedPreferencesService>();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      final cents = await sharedPrefService.isSettingsCentsVisible();
      final tags = await sharedPrefService.isSettingsTagsVisible();
      setProtectedState(() {
        isColorsVisible = colors;
        isCentsVisible = cents;
        isTagsVisible = tags;
      });

      if (!mounted) return;
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    _scrollSub.cancel();
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
