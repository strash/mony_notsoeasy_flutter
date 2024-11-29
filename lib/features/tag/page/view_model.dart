import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/tag/page/view.dart";
import "package:mony_app/features/tag/use_case/use_case.dart";

final class TagViewModelBuilder extends StatefulWidget {
  final TagModel tag;

  const TagViewModelBuilder({
    super.key,
    required this.tag,
  });

  @override
  ViewModelState<TagViewModelBuilder> createState() => TagViewModel();
}

final class TagViewModel extends ViewModelState<TagViewModelBuilder> {
  late final StreamSubscription<Event> _appSub;

  final prefix = StringEx.random(10);

  late final FeedScrollController _scrollController;
  ScrollController get controller => _scrollController.controller;

  late TagModel tag = widget.tag;

  TagBalanceModel? balance;
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
    return ViewModel(
      viewModel: this,
      useCases: [
        () => OnTransactionPressed(),
      ],
      child: const TagView(),
    );
  }
}
