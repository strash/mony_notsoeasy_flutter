import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/feed_scroll_controller/feed_scroll_controller.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/tags/page/view.dart";
import "package:mony_app/features/tags/use_case/use_case.dart";

final class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  ViewModelState<TagsPage> createState() => TagsViewModel();
}

final class TagsViewModel extends ViewModelState<TagsPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<FeedScrollControllerEvent> _scrollSub;

  List<TagModel> tags = const [];
  int scrollPage = 0;
  bool canLoadMore = true;

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
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
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
    return ViewModel<TagsViewModel>(
      viewModel: this,
      useCases: [
        () => OnAddTagPressed(),
        () => OnTagPressed(),
      ],
      child: const TagsView(),
    );
  }
}
