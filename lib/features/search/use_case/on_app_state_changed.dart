import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({Event event, SearchViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;

    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    final transactionService = context.read<DomainTransactionService>();

    final query = viewModel.input.text.trim();

    if (!context.mounted) return;

    switch (event) {
      case EventSettingsThemeModeChanged() ||
          EventSettingsDataDeletionRequested():
        break;

      case EventAccountCreated():
        final counts = await _updateCounts(context);
        final tabIndex = ESearchTab.accounts.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        final accounts = await Future.wait<List<AccountModel>>(
          List.generate(scrollPage + 1, (index) {
            return accountService.search(query: query, page: index);
          }),
        );
        viewModel.accounts = accounts.fold([], (prev, curr) {
          return prev..addAll(curr);
        });
        final balances = await Future.wait(
          viewModel.accounts.map((e) => accountService.getBalance(id: e.id)),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: scrollPage,
            canLoadMore: accounts.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.balances = balances.nonNulls.toList();
          viewModel.counts = counts;
        });

      case EventAccountUpdated() || EventAccountDeleted():
        final close = context.close;
        final count = await accountService.count();
        if (event is EventAccountDeleted && count == 0) {
          close();
          return;
        }
        if (!context.mounted) return;
        final counts = await _updateCounts(context);
        final List<List<AccountModel>> accounts = [];
        int page = 0;
        final tabIndex = ESearchTab.accounts.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        do {
          accounts.add(await accountService.search(query: query, page: page++));
        } while (page <= scrollPage &&
            (accounts.lastOrNull?.isNotEmpty ?? false));
        viewModel.accounts = accounts.fold([], (prev, curr) {
          return prev..addAll(curr);
        });
        final balances = await Future.wait(
          viewModel.accounts.map((e) => accountService.getBalance(id: e.id)),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: page,
            canLoadMore: accounts.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.balances = balances.nonNulls.toList();
          viewModel.counts = counts;
        });

      case EventAccountBalanceExchanged(value: final accounts):
        final (left, right) = accounts;
        final leftBalance = await accountService.getBalance(id: left.id);
        final rightBalance = await accountService.getBalance(id: right.id);
        viewModel.setProtectedState(() {
          viewModel.accounts = List<AccountModel>.from(
            viewModel.accounts.map((e) {
              if (e.id == left.id) {
                return left.copyWith();
              } else if (e.id == right.id) {
                return right.copyWith();
              }
              return e;
            }),
          );
          viewModel.balances = List<AccountBalanceModel>.from(
            viewModel.balances.map((e) {
              if (e.id == leftBalance?.id) {
                return leftBalance;
              } else if (e.id == rightBalance?.id) {
                return rightBalance;
              }
              return e;
            }),
          );
          viewModel.transactions = List<TransactionModel>.from(
            viewModel.transactions.map((e) {
              if (e.account.id == left.id) {
                return e.copyWith(account: left.copyWith());
              } else if (e.account.id == right.id) {
                return e.copyWith(account: right.copyWith());
              }
              return e;
            }),
          );
        });

      case EventCategoryCreated():
        final counts = await _updateCounts(context);
        final tabIndex = ESearchTab.categories.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        final categories = await Future.wait<List<CategoryModel>>(
          List.generate(scrollPage + 1, (index) {
            return categoryService.search(query: query, page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: scrollPage,
            canLoadMore: categories.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.categories = categories.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
          viewModel.counts = counts;
        });

      case EventCategoryUpdated() || EventCategoryDeleted():
        final counts = await _updateCounts(context);
        final List<List<CategoryModel>> categories = [];
        int page = 0;
        final tabIndex = ESearchTab.categories.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        do {
          categories.add(
            await categoryService.search(query: query, page: page++),
          );
        } while (page <= scrollPage &&
            (categories.lastOrNull?.isNotEmpty ?? false));
        final balances = await Future.wait(
          viewModel.balances.map((e) => accountService.getBalance(id: e.id)),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: page,
            canLoadMore: categories.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.categories = categories.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
          viewModel.balances = balances.nonNulls.toList();
          viewModel.counts = counts;
        });

      case EventTagCreated():
        final counts = await _updateCounts(context);
        final tabIndex = ESearchTab.tags.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        final tags = await Future.wait<List<TagModel>>(
          List.generate(scrollPage + 1, (index) {
            return tagService.search(query: query, page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: scrollPage,
            canLoadMore: tags.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.tags = tags.fold([], (prev, curr) => prev..addAll(curr));
          viewModel.counts = counts;
        });

      case EventTagUpdated() || EventTagDeleted():
        final counts = await _updateCounts(context);
        final List<List<TagModel>> tags = [];
        int page = 0;
        final tabIndex = ESearchTab.tags.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        do {
          tags.add(await tagService.search(query: query, page: page++));
        } while (page <= scrollPage && (tags.lastOrNull?.isNotEmpty ?? false));
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: page,
            canLoadMore: tags.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.tags = tags.fold([], (prev, curr) => prev..addAll(curr));
          viewModel.counts = counts;
        });

      case EventTransactionCreated():
        final counts = await _updateCounts(context);
        final tabIndex = ESearchTab.transactions.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        final transactions = await Future.wait<List<TransactionModel>>(
          List.generate(scrollPage + 1, (index) {
            return transactionService.search(query: query, page: index);
          }),
        );
        final balances = await Future.wait(
          viewModel.balances.map((e) => accountService.getBalance(id: e.id)),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: scrollPage,
            canLoadMore: transactions.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.transactions = transactions.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
          viewModel.balances = balances.nonNulls.toList();
          viewModel.counts = counts;
        });

      case EventTransactionUpdated() || EventTransactionDeleted():
        final List<List<TransactionModel>> transactions = [];
        int page = 0;
        final tabIndex = ESearchTab.transactions.index;
        final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates.elementAt(
          tabIndex,
        );
        do {
          transactions.add(
            await transactionService.search(query: query, page: page++),
          );
        } while (page <= scrollPage &&
            (transactions.lastOrNull?.isNotEmpty ?? false));
        final balances = await Future.wait(
          viewModel.balances.map((e) => accountService.getBalance(id: e.id)),
        );
        viewModel.setProtectedState(() {
          viewModel.tabPageStates[tabIndex] = (
            scrollPage: page,
            canLoadMore: transactions.lastOrNull?.isNotEmpty ?? false,
          );
          viewModel.balances = balances.nonNulls.toList();
          viewModel.transactions = transactions.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventDataImported():
        final counts = await _updateCounts(context);
        for (final tab in ESearchTab.values) {
          final tabIndex = tab.index;
          final (:scrollPage, canLoadMore: _) = viewModel.tabPageStates
              .elementAt(tabIndex);
          List<List<Object>> data = [];
          switch (tab) {
            case ESearchTab.transactions:
              data = await Future.wait<List<TransactionModel>>(
                List.generate(scrollPage + 1, (index) {
                  return transactionService.search(query: query, page: index);
                }),
              );
              viewModel.setProtectedState(() {
                viewModel.transactions = data
                    .cast<List<TransactionModel>>()
                    .fold([], (prev, curr) {
                      return prev..addAll(curr);
                    });
              });
            case ESearchTab.accounts:
              data = await Future.wait<List<AccountModel>>(
                List.generate(scrollPage + 1, (index) {
                  return accountService.search(query: query, page: index);
                }),
              );
              viewModel.accounts = data.cast<List<AccountModel>>().fold(
                [],
                (prev, curr) => prev..addAll(curr),
              );
              final balances = await Future.wait(
                viewModel.accounts.map(
                  (e) => accountService.getBalance(id: e.id),
                ),
              );
              viewModel.setProtectedState(() {
                viewModel.balances = balances.nonNulls.toList();
              });
            case ESearchTab.categories:
              data = await Future.wait<List<CategoryModel>>(
                List.generate(scrollPage + 1, (index) {
                  return categoryService.search(query: query, page: index);
                }),
              );
              viewModel.setProtectedState(() {
                viewModel.categories = data.cast<List<CategoryModel>>().fold(
                  [],
                  (prev, curr) => prev..addAll(curr),
                );
              });
            case ESearchTab.tags:
              data = await Future.wait<List<TagModel>>(
                List.generate(scrollPage + 1, (index) {
                  return tagService.search(query: query, page: index);
                }),
              );
              viewModel.setProtectedState(() {
                viewModel.tags = data.cast<List<TagModel>>().fold(
                  [],
                  (prev, curr) => prev..addAll(curr),
                );
              });
          }
          viewModel.setProtectedState(() {
            viewModel.tabPageStates[tabIndex] = (
              scrollPage: scrollPage,
              canLoadMore: data.lastOrNull?.isNotEmpty ?? false,
            );
          });
        }
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isColorsVisible = value;
        });

      case EventSettingsCentsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isCentsVisible = value;
        });

      case EventSettingsTagsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isTagsVisible = value;
        });
    }
  }

  Future<Map<ESearchPage, int>> _updateCounts(BuildContext context) async {
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    return {
      for (final page in ESearchPage.values)
        page: await switch (page) {
          ESearchPage.accounts => accountService.count(),
          ESearchPage.categories => categoryService.count(),
          ESearchPage.tags => tagService.count(),
        },
    };
  }
}
