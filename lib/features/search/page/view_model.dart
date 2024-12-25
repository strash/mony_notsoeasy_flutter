import "dart:async";

import "package:flutter/widgets.dart";
import "package:mony_app/app.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/common/utils/input_controller/controller.dart";
import "package:mony_app/domain/models/models.dart";
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

  Map<ESearchPage, int> counts = {
    for (final page in ESearchPage.values) page: 0,
  };

  final List<TransactionModel> transactions = const [];
  final List<AccountModel> accounts = const [];
  final List<CategoryModel> categories = const [];
  final List<TagModel> tags = const [];

  void _setSearchStatus() {
    setProtectedState(() {
      isSearching = input.focus.hasFocus || input.text.trim().isNotEmpty;
    });
  }

  void _onInputFocused() {
    _setSearchStatus();
  }

  void _onInputChanged() {
    OnInputChanged().call(context, input.text.trim());
    _setSearchStatus();
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    input.focus.addListener(_onInputFocused);
    input.addListener(_onInputChanged);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    input.focus.removeListener(_onInputFocused);
    input.removeListener(_onInputChanged);
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SearchViewModel>(
      viewModel: this,
      useCases: [
        () => OnClearButtonPressed(),
        () => OnPagePressed(),
      ],
      child: Builder(
        builder: (context) {
          OnPageCountRequested().call(context);

          return const SearchView();
        },
      ),
    );
  }
}
