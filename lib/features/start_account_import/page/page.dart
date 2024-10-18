import "package:flutter/material.dart";
import "package:mony_app/features/start_account_import/page/view_model.dart";

export "./event.dart";
export "./view_model.dart";

class StartAccountImportPage extends StatelessWidget {
  const StartAccountImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StartAccountImportViewModelBuilder();
  }
}
