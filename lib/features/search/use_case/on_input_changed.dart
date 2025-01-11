import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = (String query, SearchViewModel viewModel);

final class OnInputChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (query, viewModel) = value;

    final transactionService = context.read<DomainTransactionService>();
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();

    // reset pages
    for (int i = 0; i < viewModel.tabPageStates.length; i++) {
      viewModel.tabPageStates[i] = (scrollPage: 0, canLoadMore: true);
    }

    final transactions = await transactionService.search(
      query: query,
      page: 0,
    );
    final accounts = await accountService.search(query: query, page: 0);
    final categories = await categoryService.search(query: query, page: 0);
    final tags = await tagService.search(query: query, page: 0);

    viewModel.setProtectedState(() {
      viewModel.transactions = transactions;
      viewModel.accounts = accounts;
      viewModel.categories = categories;
      viewModel.tags = tags;
    });
  }
}
