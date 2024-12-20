import "package:flutter/material.dart";
import "package:mony_app/components/appbar/component.dart";

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarComponent(
            title: Text("Категории"),
            useSliver: true,
          ),
        ],
      ),
    );
  }
}
