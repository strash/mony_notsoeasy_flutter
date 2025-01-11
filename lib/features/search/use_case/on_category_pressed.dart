import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/features.dart";

final class OnCategoryPressed extends UseCase<void, CategoryModel> {
  @override
  void call(BuildContext context, [CategoryModel? value]) {
    if (value == null) throw ArgumentError.notNull();

    context.go(CategoryPage(category: value));
  }
}
