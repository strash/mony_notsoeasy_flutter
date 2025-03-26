import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/search/page/view_model.dart";

typedef _TValue = (String query, SearchViewModel viewModel);

final class OnInputChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (query, viewModel) = value;

    final transactionService = context.service<DomainTransactionService>();
    final accountService = context.service<DomainAccountService>();
    final categoryService = context.service<DomainCategoryService>();
    final tagService = context.service<DomainTagService>();

    // reset pages
    for (int i = 0; i < viewModel.tabPageStates.length; i++) {
      viewModel.tabPageStates[i] = (scrollPage: 0, canLoadMore: true);
    }

    final transactions = await transactionService.search(query: query, page: 0);
    final accounts = await accountService.search(query: query, page: 0);
    final balances = await Future.wait(
      accounts.map((e) => accountService.getBalance(id: e.id)),
    );
    final categories = await categoryService.search(query: query, page: 0);
    final tags = await tagService.search(query: query, page: 0);

    final resultCount = {
      for (final page in ESearchTab.values)
        page: await switch (page) {
          ESearchTab.transactions => transactionService.searchCount(
            query: query,
          ),
          ESearchTab.accounts => accountService.searchCount(query: query),
          ESearchTab.categories => categoryService.searchCount(query: query),
          ESearchTab.tags => tagService.searchCount(query: query),
        },
    };

    viewModel.setProtectedState(() {
      viewModel.transactions = transactions;
      viewModel.accounts = accounts;
      viewModel.balances = balances.nonNulls.toList();
      viewModel.categories = categories;
      viewModel.tags = tags;

      viewModel.resultCount = resultCount;
    });
  }
}
