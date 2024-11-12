import "package:flutter/material.dart";
import "package:mony_app/features/stats/page/view_model.dart";

export "./view_model.dart";

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatsViewModelBuilder();
  }
}
