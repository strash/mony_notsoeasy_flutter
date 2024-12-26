import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:provider/provider.dart";

final class OnPageCountRequested
    extends UseCase<Future<void>, SearchViewModel> {
  @override
  Future<void> call(BuildContext context, [SearchViewModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();

    final Map<ESearchPage, int> counts = {
      for (final page in ESearchPage.values)
        page: await switch (page) {
          ESearchPage.accounts => accountService.count(),
          ESearchPage.categories => categoryService.count(),
          ESearchPage.tags => tagService.count(),
        },
    };

    value.setProtectedState(() {
      value.counts = counts;
    });
  }
}
