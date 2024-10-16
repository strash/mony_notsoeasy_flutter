import "package:flutter/material.dart";
import "package:mony_app/features/start_account_create/page/view_model.dart";

export "./view_model.dart";

class StartAccountCreatePage extends StatelessWidget {
  const StartAccountCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartAccountCreateViewModelBuilder();
  }
}
