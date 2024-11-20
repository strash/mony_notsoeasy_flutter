import "package:flutter/material.dart";
import "package:mony_app/features/features.dart";

export "./view_model.dart";

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavBarViewModelBuilder();
  }
}
