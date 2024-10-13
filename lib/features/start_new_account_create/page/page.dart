import "package:flutter/material.dart";
import "package:mony_app/features/start_new_account_create/page/view_model.dart";

export "./view_model.dart";

class StartNewAccountCreatePage extends StatelessWidget {
  const StartNewAccountCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartNewAccountCreateViewModelBuilder();
  }
}
