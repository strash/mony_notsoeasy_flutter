import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/feed_scroll_controller/feed_scroll_controller.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/components/account_with_context_menu/use_case/use_case.dart";
import "package:mony_app/components/category_with_context_menu/use_case/use_case.dart";
import "package:mony_app/components/tag_with_context_menu/use_case/use_case.dart";
import "package:mony_app/components/transaction_with_context_menu/component.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/search/page/view.dart";
import "package:mony_app/features/search/use_case/use_case.dart";
import "package:mony_app/gen/assets.gen.dart";

part "./enums.dart";
part "./route.dart";

final class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  static void show(BuildContext context) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    navigator.push<void>(
      _Route(
        child: const SearchPage(),
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
      ),
    );
  }

  @override
  ViewModelState<SearchPage> createState() => SearchViewModel();
}

final class SearchViewModel extends ViewModelState<SearchPage> {
  late final StreamSubscription<Event> _appSub;

  final input = InputController();
  bool isSearching = false;
  ESearchTab activeTab = ESearchTab.defaultValue;

  final tabButtonsScrollController = ScrollController();

  late final _pageTabScrollControllers = ESearchTab.values
      .map((e) => FeedScrollController())
      .toList(growable: false);

  late final List<StreamSubscription<FeedScrollControllerEvent>>
  _pageTabScrollSubs;

  final List<({int scrollPage, bool canLoadMore})> tabPageStates = List.filled(
    ESearchTab.values.length,
    (scrollPage: 0, canLoadMore: true),
  );

  Map<ESearchPage, int> counts = {
    for (final page in ESearchPage.values) page: 0,
  };

  List<TransactionModel> transactions = const [];
  List<AccountModel> accounts = const [];
  List<AccountBalanceModel> balances = const [];
  List<CategoryModel> categories = const [];
  List<TagModel> tags = const [];

  bool isCentsVisible = true;
  bool isColorsVisible = true;
  bool isTagsVisible = true;

  ScrollController getPageTabController(ESearchTab tab) {
    return _pageTabScrollControllers.elementAt(tab.index).controller;
  }

  void _onInputChanged() {
    OnInputChanged().call(context, (input.text.trim(), this));
    setProtectedState(() {
      isSearching = input.text.trim().isNotEmpty;
    });
  }

  void _onScroll(FeedScrollControllerEvent event) {
    OnPageTabScrolled().call(context, (input.text.trim(), this));
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    input.addListener(_onInputChanged);
    _pageTabScrollSubs = _pageTabScrollControllers
        .map((e) => e.addListener(_onScroll))
        .toList(growable: false);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      final sharedPrefService =
          context.service<DomainSharedPreferencesService>();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      final cents = await sharedPrefService.isSettingsCentsVisible();
      final tags = await sharedPrefService.isSettingsTagsVisible();
      setProtectedState(() {
        isColorsVisible = colors;
        isCentsVisible = cents;
        isTagsVisible = tags;
      });

      if (!mounted) return;
      OnPageCountRequested().call(context, this);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    input.removeListener(_onInputChanged);
    input.dispose();
    tabButtonsScrollController.dispose();

    void cancelForeach(StreamSubscription<FeedScrollControllerEvent> sub) {
      sub.cancel();
    }

    _pageTabScrollSubs.forEach(cancelForeach);

    void disposeForeach(FeedScrollController controller) {
      controller.dispose();
    }

    _pageTabScrollControllers.forEach(disposeForeach);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SearchViewModel>(
      viewModel: this,
      useCases: [
        () => OnClearButtonPressed(),
        () => OnTabButtonPressed(),
        () => OnPagePressed(),
        () => OnTransactionWithContextMenuPressed(),
        () => OnTransactionWithContextMenuSelected(),
        () => OnAccountPressed(),
        () => OnAccountWithContextMenuSelected(),
        () => OnCategoryPressed(),
        () => OnCategoryWithContextMenuSelected(),
        () => OnTagPressed(),
        () => OnTagWithContextMenuSelected(),
      ],
      child: const SearchView(),
    );
  }
}
