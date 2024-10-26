import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";

final class OnCategoryButtonPressed
    extends UseCase<Future<void>, TPressedCategoryValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TPressedCategoryValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();
    // show action menu
    final sheetResult =
        await BottomSheetComponent.show<EImportCategoryMenuAction?>(
      context,
      builder: (context, bottom) {
        return const ImportCategoryActionBottomSheetComponent();
      },
    );
    if (sheetResult == null || !context.mounted) return;
    final viewModel = context.viewModel<ImportViewModel>();
    // show category model selector
    if (sheetResult == EImportCategoryMenuAction.link) {
      final models = viewModel.categoryModels[value.transactionType];
      if (models == null) return;
      final selectResult = await BottomSheetComponent.show<CategoryModel?>(
        context,
        builder: (context, bottom) {
          return ImportCategorySelectBottomSheetCotponent(
            categories: models,
          );
        },
      );
      if (selectResult != null) {
        final mapped = viewModel.mappedCategories[value.transactionType]!;
        final index = mapped.indexOf(value.category);
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
    } else if (sheetResult == EImportCategoryMenuAction.create) {
      print("do some shit");
    }
  }
}
