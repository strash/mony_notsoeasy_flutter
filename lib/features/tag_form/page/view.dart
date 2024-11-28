import "package:flutter/material.dart";
import "package:mony_app/components/appbar/component.dart";

class TagFormView extends StatelessWidget {
  final double keyboardHeight;

  const TagFormView({
    super.key,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        const AppBarComponent(
          title: Text("Счет"),
          useSliver: false,
          showBackground: false,
          showDragHandle: true,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            child: Text("yaya"),
          ),
        ),

        SizedBox(height: 40.0 + keyboardHeight),
      ],
    );
  }
}
