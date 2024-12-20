import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:provider/provider.dart";

final class OnPageCountRequested extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    final viewModel = context.viewModel<SearchViewModel>();

    final Map<ESearchPage, int> counts = {
      for (final page in ESearchPage.values)
        page: await switch (page) {
          ESearchPage.accounts => accountService.count(),
          ESearchPage.categories => categoryService.count(),
          ESearchPage.tags => tagService.count(),
        },
    };

    viewModel.setProtectedState(() {
      viewModel.pageCounts = counts;
    });
  }
}
