import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/import/page/view_model.dart";

final class OnCategoryResetPressed
    extends UseCase<void, ImportModelCategoryVariant> {
  @override
  void call(BuildContext context, [ImportModelCategoryVariant? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<ImportViewModel>();
    final categoryModel = viewModel.currentStep;
    if (categoryModel is! ImportModelCategory) {
      throw ArgumentError.value(categoryModel);
    }

    categoryModel.remap(switch (value) {
      ImportModelCategoryVariantEmpty() => value,
      final ImportModelCategoryVariantModel item => item.toEmpty(),
      final ImportModelCategoryVariantVO item => item.toEmpty(),
    });

    // NOTE: trigger the step navigation to check if model is ready
    viewModel.setProtectedState(() {});
  }
}
