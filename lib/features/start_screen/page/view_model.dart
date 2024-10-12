import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_screen/page/view.dart";
import "package:mony_app/features/start_screen/use_case/use_case.dart";

final class StartScreenViewModelBuilder extends StatefulWidget {
  const StartScreenViewModelBuilder({super.key});

  @override
  ViewModelState<StartScreenViewModelBuilder> createState() =>
      StartScreenViewModel();
}

final class StartScreenViewModel
    extends ViewModelState<StartScreenViewModelBuilder> {
  final onButtonStartPressed = OnButtonStartPressedUseCase();

  @override
  Widget build(BuildContext context) {
    return ViewModel<StartScreenViewModel>(
      viewModel: this,
      child: const StartScreenView(),
    );
  }
}
