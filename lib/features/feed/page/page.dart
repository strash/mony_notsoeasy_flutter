import "package:flutter/material.dart";
import "package:mony_app/features/feed/page/view_model.dart";

export "./view_model.dart";

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeedViewModelBuilder();
  }
}
