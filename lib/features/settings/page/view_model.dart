import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/settings/page/view.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  ViewModelState<SettingsPage> createState() => SettingsViewModel();
}

final class SettingsViewModel extends ViewModelState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModel<SettingsViewModel>(
      viewModel: this,
      child: const SettingsView(),
    );
  }
}
