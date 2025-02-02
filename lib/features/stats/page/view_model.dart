import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/charts/component.dart";
import "package:mony_app/components/select/select.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/navbar/navbar.dart";
import "package:mony_app/features/navbar/page/event.dart";
import "package:mony_app/features/stats/page/view.dart";
import "package:mony_app/features/stats/use_case/use_case.dart";
import "package:provider/provider.dart";

final class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  ViewModelState<StatsPage> createState() => StatsViewModel();
}

final class StatsViewModel extends ViewModelState<StatsPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<NavBarEvent> _navbarSub;

  bool isCentsVisible = true;
  bool isColorsVisible = true;
  bool isTagsVisible = true;

  final scrollController = ScrollController();
  final categoryScrollController = ScrollController();

  EChartTemporalView activeTemporalView = EChartTemporalView.defaultValue;
  late final accountController = SelectController<AccountModel?>(null);
  ETransactionType activeTransactionType = ETransactionType.defaultValue;

  List<AccountModel> accounts = [];
  AccountBalanceModel? activeAccountBalance;
  List<TransactionModel> transactions = [];

  DateTime activeYear = DateTime.now().startOfDay;
  DateTime activeMonth = DateTime.now().startOfDay;
  DateTime activeWeek = DateTime.now().startOfDay;

  (DateTime, DateTime) get exclusiveDateRange {
    final loc = MaterialLocalizations.of(context);
    final DateTime from;
    final DateTime to;
    switch (activeTemporalView) {
      case EChartTemporalView.year:
        final list = activeYear.monthsOfYear();
        from = list.first;
        to = list.last.offsetMonth(1);
      case EChartTemporalView.month:
        final list = activeMonth.daysOfMonth();
        from = list.first;
        to = list.last.add(const Duration(days: 1));
      case EChartTemporalView.week:
        final list = activeWeek.daysOfWeek(loc);
        from = list.first;
        to = list.last.add(const Duration(days: 1));
    }
    return (from, to);
  }

  List<(double, CategoryModel)> get categories {
    final List<(double, CategoryModel)> list = [];
    for (final element in transactions) {
      final amount = element.amount.abs();
      final index = list.indexWhere((e) => e.$2.id == element.category.id);
      if (index == -1) {
        list.add((amount, element.category));
        continue;
      }
      final item = list.elementAt(index);
      list[index] = (item.$1 + amount, element.category);
    }
    list.sort((a, b) => b.$1.compareTo(a.$1));
    return list;
  }

  void resetCategoryScrollController() {
    if (!categoryScrollController.isReady) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoryScrollController.jumpTo(1.0);
      categoryScrollController.jumpTo(.0);
    });
  }

  void _onAccountSelected() {
    OnAccountSelected().call(context, this);
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    // TODO
    // OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  void _onNavBarEvent(NavBarEvent e) {
    if (!context.mounted) return;
    final navBar = context.viewModel<NavBarViewModel>();
    if (navBar.currentTab != ENavBarTabItem.stats) return;

    switch (e) {
      case NavBarEventTabChanged():
        break;
      case NavBarEventScrollToTopRequested():
        // -> scroll to top
        if (scrollController.isReady && scrollController.position.pixels > .0) {
          navBar.returnToTop(scrollController);
          // -> set current date
        } else {
          // TODO
          // if (currentPageIndex == 0 || _pagingToStart) return;
          // openPage(0);
        }
      case NavBarEventAddTransactionPressed():
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

      accountController.addListener(_onAccountSelected);

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
    _navbarSub.cancel();
    accountController.dispose();
    scrollController.dispose();
    categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<StatsViewModel>(
      viewModel: this,
      useCases: [
        () => OnTemporalButtonPressed(),
        () => OnTransactionTypeSelected(),
        () => OnTransactionPressed(),
      ],
      child: const StatsView(),
    );
  }
}
