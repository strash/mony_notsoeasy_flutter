import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account/page/view.dart";
import "package:mony_app/features/start_account/use_case/use_case.dart";

final class StartAccountViewModelBuilder extends StatefulWidget {
  const StartAccountViewModelBuilder({super.key});

  @override
  ViewModelState<StartAccountViewModelBuilder> createState() =>
      StartAccountViewModel();
}

final class StartAccountViewModel
    extends ViewModelState<StartAccountViewModelBuilder> {
  final onCreateAccountPressed = OnCreateAccountPressedUseCase();
  final onImportDataPressed = OnImportDataPressedUseCase();

  @override
  Widget build(BuildContext context) {
    return ViewModel<StartAccountViewModel>(
      viewModel: this,
      child: const StartAccountView(),
    );
  }
}