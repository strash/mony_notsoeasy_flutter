import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/features/tag/page/view_model.dart";

final class OnTagPressed extends UseCase<void, TagModel> {
  @override
  void call(BuildContext context, [TagModel? value]) {
    if (value == null) throw ArgumentError.notNull();

    context.go<void>(TagPage(tag: value));
  }
}
