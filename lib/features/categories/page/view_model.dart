import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/categories/page/view.dart";
import "package:mony_app/features/categories/use_case/use_case.dart";

final class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  ViewModelState<CategoriesPage> createState() => CategoriesViewModel();
}

final class CategoriesViewModel extends ViewModelState<CategoriesPage> {
  late final StreamSubscription<Event> _appSub;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<CategoriesViewModel>(
      viewModel: this,
      child: const CategoriesView(),
    );
  }
}
