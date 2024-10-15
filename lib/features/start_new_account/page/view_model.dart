import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_new_account/page/view.dart";
import "package:mony_app/features/start_new_account/use_case/use_case.dart";

final class StartNewAccountViewModelBuilder extends StatefulWidget {
  const StartNewAccountViewModelBuilder({super.key});

  @override
  ViewModelState<StartNewAccountViewModelBuilder> createState() =>
      StartNewAccountViewModel();
}

final class StartNewAccountViewModel
    extends ViewModelState<StartNewAccountViewModelBuilder> {
  final onCreateAccountPressed = OnCreateAccountPressedUseCase();
  final onImportDataPressed = OnImportDataPressedUseCase();

  @override
  Widget build(BuildContext context) {
    return ViewModel<StartNewAccountViewModel>(
      viewModel: this,
      child: const StartNewAccountView(),
    );
  }
}
