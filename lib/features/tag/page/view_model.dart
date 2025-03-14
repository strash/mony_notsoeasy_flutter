import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/tag_with_context_menu/use_case/use_case.dart";
import "package:mony_app/components/transaction_with_context_menu/component.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/tag/page/view.dart";
import "package:mony_app/features/tag/use_case/use_case.dart";
import "package:provider/provider.dart";

final class TagPage extends StatefulWidget {
  final TagModel tag;

  const TagPage({super.key, required this.tag});

  @override
  ViewModelState<TagPage> createState() => TagViewModel();
}

final class TagViewModel extends ViewModelState<TagPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<FeedScrollControllerEvent> _scrollSub;

  final prefix = StringEx.random(10);

  late final FeedScrollController _scrollController = FeedScrollController();
  ScrollController get controller => _scrollController.controller;

  late TagModel tag = widget.tag;

  TagBalanceModel? balance;
  List<TransactionModel> feed = [];
  int scrollPage = 0;
  bool canLoadMore = true;

  bool isColorsVisible = true;
  bool isCentsVisible = true;
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
      await OnInit().call(context, this);
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
    return ViewModel(
      viewModel: this,
      useCases: [
        () => OnTagWithContextMenuSelected(),
        () => OnTransactionWithContextMenuPressed(),
        () => OnTransactionWithContextMenuSelected(),
      ],
      child: const TagView(),
    );
  }
}
