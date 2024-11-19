import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/features/transaction/components/tag.dart";

class TransactionTagsComponent extends StatelessWidget {
  final List<TagModel> tags;

  const TransactionTagsComponent({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.r,
      runSpacing: 6.r,
      children: tags.map((e) {
        return TransactionTagComponent(tag: e);
      }).toList(growable: false),
    );
  }
}
