import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/search/page/view_model.dart";

final class OnPageCountRequested
    extends UseCase<Future<void>, SearchViewModel> {
  @override
  Future<void> call(BuildContext context, [SearchViewModel? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final accountService = context.service<DomainAccountService>();
    final categoryService = context.service<DomainCategoryService>();
    final tagService = context.service<DomainTagService>();

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
