import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start/page/view.dart";
import "package:mony_app/features/start/use_case/use_case.dart";

final class StartViewModelBuilder extends StatefulWidget {
  const StartViewModelBuilder({super.key});

  @override
  ViewModelState<StartViewModelBuilder> createState() => StartViewModel();
}

final class StartViewModel extends ViewModelState<StartViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<StartViewModel>(
      viewModel: this,
      useCases: [
        () => OnButtonStartPressed(),
      ],
      child: const StartView(),
    );
  }
}
