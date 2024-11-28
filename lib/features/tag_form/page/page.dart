import "package:flutter/material.dart";
import "package:mony_app/domain/services/database/vo/tag.dart";
import "package:mony_app/features/features.dart";

export "./view_model.dart";

class TagFormPage extends StatelessWidget {
  final double keyboardHeight;
  final TagVariant? tag;
  final List<String>? additionalUsedTitles;

  const TagFormPage({
    super.key,
    required this.keyboardHeight,
    this.tag,
    this.additionalUsedTitles,
  });

  @override
  Widget build(BuildContext context) {
    return TagFormViewModelBuilder(
      keyboardHeight: keyboardHeight,
      tag: tag,
      additionalUsedTitles: additionalUsedTitles ?? const [],
    );
  }
}
