import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/import/page/view_model.dart";

final class OnCategoryResetPressed
    extends UseCase<void, ImportModelCategoryVO> {
  @override
  void call(BuildContext context, [ImportModelCategoryVO? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<ImportViewModel>();
    final categoryModel = viewModel.currentStep;
    if (categoryModel is! ImportModelCategory) {
      throw ArgumentError.value(categoryModel);
    }

    categoryModel.remap(
      switch (value) {
        ImportModelCategoryVOEmpty() => value,
        final ImportModelCategoryVOModel item => item.toEmpty(),
        final ImportModelCategoryVOVO item => item.toEmpty(),
      },
    );

    // NOTE: trigger the step navigation to check if model is ready
    viewModel.setProtectedState(() {});
  }
}
