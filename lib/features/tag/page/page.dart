import "package:flutter/material.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/features/tag/page/view_model.dart";

export "./view_model.dart";

class TagPage extends StatelessWidget {
  final TagModel tag;

  const TagPage({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return TagViewModelBuilder(tag: tag);
  }
}
