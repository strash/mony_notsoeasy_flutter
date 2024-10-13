import "package:flutter/material.dart";
import "package:mony_app/features/start/page/view_model.dart";

export "./view_model.dart";

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartViewModelBuilder();
  }
}
