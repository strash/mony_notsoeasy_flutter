import "package:flutter/material.dart";
import "package:mony_app/components/appbar/component.dart";

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarComponent(
            title: Text("Счета"),
            useSliver: true,
          ),
        ],
      ),
    );
  }
}
