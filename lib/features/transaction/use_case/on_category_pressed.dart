import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/category/page/page.dart";

final class OnCategoryPressed extends UseCase<void, CategoryModel> {
  @override
  void call(BuildContext context, [CategoryModel? value]) {
    if (value == null) throw ArgumentError.notNull();

    context.go<void>(CategoryPage(category: value));
  }
}
