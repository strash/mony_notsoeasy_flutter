import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/categories/categories.dart";

final class OnDataFetchRequested
    extends UseCase<Future<void>, CategoriesViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    CategoriesViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();
    if (!viewModel.canLoadMore) return;

    final categoryService = context.service<DomainCategoryService>();

    final categories = await categoryService.getMany(
      page: viewModel.scrollPage,
    );

    viewModel.setProtectedState(() {
      viewModel.scrollPage += 1;
      viewModel.canLoadMore = categories.isNotEmpty;
      viewModel.categories = viewModel.categories.merge(categories);
    });
  }
}
