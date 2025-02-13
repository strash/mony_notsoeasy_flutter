import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/feed_scroll_controller/feed_scroll_controller.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/categories/page/view.dart";
import "package:mony_app/features/categories/use_case/use_case.dart";
import "package:provider/provider.dart";

final class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  ViewModelState<CategoriesPage> createState() => CategoriesViewModel();
}

final class CategoriesViewModel extends ViewModelState<CategoriesPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<FeedScrollControllerEvent> _scrollSub;

  List<CategoryModel> categories = const [];
  int scrollPage = 0;
  bool canLoadMore = true;

  bool isColorsVisible = true;

  final _scrollController = FeedScrollController();
  ScrollController get controller => _scrollController.controller;

  void _onFeedEvent(FeedScrollControllerEvent event) {
    if (!mounted) return;
    OnDataFetchRequested().call(context, this);
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
      setProtectedState(() {
        isColorsVisible = colors;
      });

      if (!mounted) return;
      OnDataFetchRequested().call(context, this);
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
    return ViewModel<CategoriesViewModel>(
      viewModel: this,
      useCases: [() => OnMenuAddPressed(), () => OnCategoryPressed()],
      child: const CategoriesView(),
    );
  }
}
