import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_screen_new_account/page/view.dart";

final class StartScreenNewAccountViewModelBuilder extends StatefulWidget {
  const StartScreenNewAccountViewModelBuilder({super.key});

  @override
  ViewModelState<StartScreenNewAccountViewModelBuilder> createState() =>
      StartScreenNewAccountViewModel();
}

final class StartScreenNewAccountViewModel
    extends ViewModelState<StartScreenNewAccountViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<StartScreenNewAccountViewModel>(
      viewModel: this,
      child: const StartScreenNewAccountView(),
    );
  }
}
