import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/components.dart";

final class OnCategoryButtonPressed
    extends UseCase<Future<void>, ImportModelCategoryVariant> {
  @override
  Future<void> call(
    BuildContext context, [
    ImportModelCategoryVariant? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    final sheetResult = switch (value) {
      // show action menu
      ImportModelCategoryVariantEmpty() =>
        await BottomSheetComponent.show<EImportCategoryMenuAction?>(
          context,
          builder: (context, bottom) {
            return const ImportCategoryActionBottomSheetComponent();
          },
        ),
      // link model
      ImportModelCategoryVariantModel() => EImportCategoryMenuAction.link,
      // create vo
      ImportModelCategoryVariantVO() => EImportCategoryMenuAction.create,
    };
    if (!context.mounted || sheetResult == null) return;

    final viewModel = context.viewModel<ImportViewModel>();
    final categoryModel = viewModel.currentStep;
    if (categoryModel is! ImportModelCategory) {
      throw ArgumentError.value(categoryModel);
    }
    final models = viewModel.categoryModels[value.transactionType];
    if (models == null) return;

    switch (sheetResult) {
      // show category model selector
      case EImportCategoryMenuAction.link:
        final result = await BottomSheetComponent.show<CategoryModel?>(
          context,
          builder: (context, bottom) {
            return ImportCategorySelectBottomSheetCotponent(categories: models);
          },
        );
        if (result == null) return;
        switch (value) {
          case final ImportModelCategoryVariantEmpty item:
            categoryModel.remap(item.toModel(model: result));
          case final ImportModelCategoryVariantModel item:
            categoryModel.remap(item.copyWith(model: result));
          case ImportModelCategoryVariantVO():
            break;
        }

      // show new category form
      case EImportCategoryMenuAction.create:
        final categoryVO = switch (value) {
          ImportModelCategoryVariantVO(:final vo) => vo,
          _ => CategoryVO(
              title: value.originalTitle,
              icon: "",
              colorName: EColorName.random().name,
              transactionType: value.transactionType,
            ),
        };
        final List<String> titles;
        if (value case final ImportModelCategoryVariantVO vo) {
          titles = categoryModel.getTitles(vo);
        } else {
          titles = const [];
        }
        final result = await BottomSheetComponent.show<CategoryVO?>(
          context,
          showDragHandle: false,
          builder: (context, bottom) {
            return CategoryFormPage(
              category: CategoryVariantVO(vo: categoryVO),
              transactionType: value.transactionType,
              keyboardHeight: bottom,
              additionalUsedTitles: titles,
            );
          },
        );
        if (result == null) return;
        switch (value) {
          case final ImportModelCategoryVariantEmpty item:
            categoryModel.remap(item.toVO(vo: result));
          case ImportModelCategoryVariantModel():
            break;
          case final ImportModelCategoryVariantVO item:
            categoryModel.remap(item.copyWith(vo: result));
        }
    }

    // NOTE: trigger the step navigation to check if model is ready
    viewModel.setProtectedState(() {});
  }
}
