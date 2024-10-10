import "package:flutter/widgets.dart";
import "package:mony_app/features/settings/page/view_model.dart";

export "./view_model.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsViewModelBuilder();
  }
}
