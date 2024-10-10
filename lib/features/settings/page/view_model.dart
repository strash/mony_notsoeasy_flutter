import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/settings/page/view.dart";

class SettingsViewModelBuilder extends StatefulWidget {
  const SettingsViewModelBuilder({super.key});

  @override
  ViewModelState<SettingsViewModelBuilder> createState() => SettingsViewModel();
}

final class SettingsViewModel extends ViewModelState<SettingsViewModelBuilder> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<SettingsViewModel>(
      viewModel: this,
      child: const SettingsView(),
    );
  }
}
