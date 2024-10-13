import "package:flutter/material.dart";
import "package:mony_app/features/start_new_account/page/view_model.dart";

export "./view_model.dart";

class StartNewAccountPage extends StatelessWidget {
  const StartNewAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartNewAccountViewModelBuilder();
  }
}
