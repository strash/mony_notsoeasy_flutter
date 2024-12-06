import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/stats/page/view.dart";

final class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  ViewModelState<StatsPage> createState() => StatsViewModel();
}

final class StatsViewModel extends ViewModelState<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<StatsViewModel>(
      viewModel: this,
      child: const StatsView(),
    );
  }
}
