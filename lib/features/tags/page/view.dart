import "package:flutter/material.dart";
import "package:mony_app/components/appbar/component.dart";

class TagsView extends StatelessWidget {
  const TagsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarComponent(
            title: Text("Теги"),
          ),
        ],
      ),
    );
  }
}
