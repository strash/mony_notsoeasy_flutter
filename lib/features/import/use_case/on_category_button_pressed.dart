import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/features.dart";
import "package:mony_app/features/import/components/components.dart";

final class OnCategoryButtonPressed
    extends UseCase<Future<void>, TPressedCategoryValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TPressedCategoryValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();

    EImportCategoryMenuAction? sheetResult;
    if (value.category.vo == null && value.category.linkedModel == null) {
      // show action menu
      sheetResult = await BottomSheetComponent.show<EImportCategoryMenuAction?>(
        context,
        builder: (context, bottom) {
          return const ImportCategoryActionBottomSheetComponent();
        },
      );
      if (sheetResult == null || !context.mounted) return;
    } else if (value.category.vo != null) {
      sheetResult = EImportCategoryMenuAction.create;
    } else if (value.category.linkedModel != null) {
      sheetResult = EImportCategoryMenuAction.link;
    }
    final viewModel = context.viewModel<ImportViewModel>();
    final models = viewModel.categoryModels[value.transactionType];
    if (models == null) return;
    final mapped = viewModel.mappedCategories[value.transactionType]!;
    final index = mapped.indexOf(value.category);

    // show category model selector
    if (sheetResult == EImportCategoryMenuAction.link) {
      final selectResult = await BottomSheetComponent.show<CategoryModel?>(
        context,
        builder: (context, bottom) {
          return ImportCategorySelectBottomSheetCotponent(
            categories: models,
          );
        },
      );
      if (selectResult != null) {
        if (index == -1) return;
        viewModel.setProtectedState(() {
          final category = (
            title: value.category.title,
            linkedModel: selectResult.copyWith(),
            vo: null,
          );
          viewModel.mappedCategories[value.transactionType] =
              List<TMappedCategory>.from(mapped)
                ..removeAt(index)
                ..insert(index, category);
        });
      }
    }

    // show new category form
    if (context.mounted && sheetResult == EImportCategoryMenuAction.create) {
      final category = value.category.vo ??
          CategoryVO(
            title: value.category.title,
            icon: "",
            sort: models.length,
            color: Palette().randomColor,
            transactionType: value.transactionType,
          );
      final createResult = await BottomSheetComponent.show<CategoryVO?>(
        context,
        showDragHandle: false,
        builder: (context, bottom) {
          return CategoryFormPage(
            category: category,
            transactionType: value.transactionType,
            keyboardHeight: bottom,
            titles: viewModel.mappedCategories[value.transactionType]!
                .where((e) => e.vo != null && e.vo != value.category.vo)
                .map((e) => e.vo!.title)
                .toList(growable: false),
          );
        },
      );
      if (createResult == null || index == -1) return;
      viewModel.setProtectedState(() {
        final category = (
          title: value.category.title,
          linkedModel: null,
          vo: createResult.copyWith(),
        );
        viewModel.mappedCategories[value.transactionType] =
            List<TMappedCategory>.from(mapped)
              ..removeAt(index)
              ..insert(index, category);
      });
    }
  }
}