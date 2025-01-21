import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_account/page/view.dart";
import "package:mony_app/features/start_account/use_case/use_case.dart";

final class StartAccountPage extends StatefulWidget {
  const StartAccountPage({super.key});

  @override
  ViewModelState<StartAccountPage> createState() => StartAccountViewModel();
}

final class StartAccountViewModel extends ViewModelState<StartAccountPage> {
  bool isImportInProgress = false;
  @override
  Widget build(BuildContext context) {
    return ViewModel<StartAccountViewModel>(
      viewModel: this,
      useCases: [
        () => OnShowAccountFormPressed(),
        () => OnImportMonyDataPressed(),
        () => OnImportCsvDataPressed(),
      ],
      child: const StartAccountView(),
    );
  }
}
