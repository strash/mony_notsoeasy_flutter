import "package:flutter/material.dart";
import "package:mony_app/features/import/page/view_model.dart";

export "./view_model.dart";

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ImportViewModelBuilder();
  }
}
