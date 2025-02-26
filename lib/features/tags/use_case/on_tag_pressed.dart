import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/features/tag/tag.dart";

final class OnTagPressed extends UseCase<Future<void>, TagModel> {
  @override
  Future<void> call(BuildContext context, [TagModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    context.go<void>(TagPage(tag: value));
  }
}
