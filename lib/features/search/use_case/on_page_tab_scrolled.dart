import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/search/page/view_model.dart";

typedef _TValue = (String query, SearchViewModel viewModel);

final class OnPageTabScrolled extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (query, viewModel) = value;

    final activeTab = viewModel.activeTab;
    final (scrollPage: scrollPage, canLoadMore: canLoadMore) = viewModel
        .tabPageStates
        .elementAt(activeTab.index);

    if (!canLoadMore) return;

    switch (activeTab) {
      case ESearchTab.transactions:
        final service = context.service<DomainTransactionService>();
        final data = await service.search(query: query, page: scrollPage + 1);
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[activeTab.index] = (
            scrollPage: scrollPage + 1,
            canLoadMore: data.isNotEmpty,
          );
          viewModel.transactions = viewModel.transactions.merge(data);
        });

      case ESearchTab.accounts:
        final service = context.service<DomainAccountService>();
        final data = await service.search(query: query, page: scrollPage + 1);
        final balances = await Future.wait(
          data.map((e) => service.getBalance(id: e.id)),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[activeTab.index] = (
            scrollPage: scrollPage + 1,
            canLoadMore: data.isNotEmpty,
          );
          viewModel.accounts.merge(data);
          viewModel.balances.merge(balances.nonNulls.toList());
        });

      case ESearchTab.categories:
        final service = context.service<DomainCategoryService>();
        final data = await service.search(query: query, page: scrollPage + 1);
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[activeTab.index] = (
            scrollPage: scrollPage + 1,
            canLoadMore: data.isNotEmpty,
          );
          viewModel.categories.merge(data);
        });

      case ESearchTab.tags:
        final service = context.service<DomainTagService>();
        final data = await service.search(query: query, page: scrollPage + 1);
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[activeTab.index] = (
            scrollPage: scrollPage + 1,
            canLoadMore: data.isNotEmpty,
          );
          viewModel.tags.merge(data);
        });
    }
  }
}
