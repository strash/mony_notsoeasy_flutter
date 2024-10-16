import "package:flutter/material.dart";
import "package:mony_app/features/start_account/page/view_model.dart";

export "./view_model.dart";

class StartAccountPage extends StatelessWidget {
  const StartAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartAccountViewModelBuilder();
  }
}
