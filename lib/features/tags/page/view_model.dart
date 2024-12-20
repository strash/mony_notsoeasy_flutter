import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/tags/page/view.dart";
import "package:mony_app/features/tags/use_case/use_case.dart";

final class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  ViewModelState<TagsPage> createState() => TagsViewModel();
}

final class TagsViewModel extends ViewModelState<TagsPage> {
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
    return ViewModel<TagsViewModel>(
      viewModel: this,
      child: const TagsView(),
    );
  }
}
