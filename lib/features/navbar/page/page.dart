import "package:flutter/material.dart";
import "package:mony_app/features/features.dart";

export "./view_model.dart";

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavbarViewModelBuilder();
  }
}
