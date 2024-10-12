import "package:flutter/material.dart";
import "package:mony_app/features/start_screen_new_account/page/view_model.dart";

export "./view_model.dart";

class StartScreenNewAccountPage extends StatelessWidget {
  const StartScreenNewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartScreenNewAccountViewModelBuilder();
  }
}
