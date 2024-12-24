import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category/category.dart";

final class OnCategoryPressed extends UseCase<void, CategoryModel> {
  @override
  void call(BuildContext context, [CategoryModel? value]) {
    if (value == null) throw ArgumentError.notNull();

    context.go(CategoryPage(category: value));
  }
}
