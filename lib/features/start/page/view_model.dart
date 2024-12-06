import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start/page/view.dart";
import "package:mony_app/features/start/use_case/use_case.dart";

final class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  ViewModelState<StartPage> createState() => StartViewModel();
}

final class StartViewModel extends ViewModelState<StartPage> {
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
