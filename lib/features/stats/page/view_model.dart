import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/stats/page/view.dart";

final class StatsViewModelBuilder extends StatefulWidget {
  const StatsViewModelBuilder({super.key});

  @override
  ViewModelState<StatsViewModelBuilder> createState() => StatsViewModel();
}

final class StatsViewModel extends ViewModelState<StatsViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<StatsViewModel>(
      viewModel: this,
      child: const StatsView(),
    );
  }
}
