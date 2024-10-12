import "package:flutter/material.dart";
import "package:mony_app/features/start_screen/page/view_model.dart";

export "./view_model.dart";

class StartScreenPage extends StatelessWidget {
  const StartScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartScreenViewModelBuilder();
  }
}
