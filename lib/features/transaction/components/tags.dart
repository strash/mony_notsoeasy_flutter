import "package:flutter/material.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/tag/component.dart";
import "package:mony_app/domain/models/tag.dart";

class TransactionTagsComponent extends StatelessWidget {
  final List<TagModel> tags;
  final UseCase<void, TagModel> onTap;

  const TransactionTagsComponent({
    super.key,
    required this.tags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: tags.map((e) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(context, e),
          child: TagComponent(tag: e),
        );
      }).toList(growable: false),
    );
  }
}
