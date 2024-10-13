import "package:flutter/material.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/features/start_new_account_create/page/view.dart";

final class StartNewAccountCreateViewModelBuilder extends StatefulWidget {
  const StartNewAccountCreateViewModelBuilder({super.key});

  @override
  ViewModelState<StartNewAccountCreateViewModelBuilder> createState() =>
      StartNewAccountCreateViewModel();
}

final class StartNewAccountCreateViewModel
    extends ViewModelState<StartNewAccountCreateViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<StartNewAccountCreateViewModel>(
      viewModel: this,
      child: const StartNewAccountCreateView(),
    );
  }
}
