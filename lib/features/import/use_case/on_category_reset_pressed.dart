import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/import/page/view_model.dart";

final class OnCategoryResetPressed
    extends UseCase<void, TPressedCategoryValue> {
  @override
  void call(BuildContext context, [TPressedCategoryValue? value]) {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<ImportViewModel>();
    // FIXME
    // final categories = viewModel.mappedCategories[value.transactionType];
    // if (categories == null) return;
    // final index = categories.indexOf(value.category);
    // if (index == -1) return;
    // viewModel.setProtectedState(() {
    //   final TMappedCategory category = (
    //     title: value.category.title,
    //     linkedModel: null,
    //     vo: null,
    //   );
    //   viewModel.mappedCategories[value.transactionType] =
    //       List<TMappedCategory>.from(categories)
    //         ..removeAt(index)
    //         ..insert(index, category);
    // });
  }
}
