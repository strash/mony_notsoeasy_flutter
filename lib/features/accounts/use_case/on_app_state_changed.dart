import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/accounts/page/view_model.dart";

typedef _TValue = ({Event event, AccountsViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountService = context.service<DomainAccountService>();

    switch (value.event) {
      case EventCategoryCreated() ||
          EventCategoryUpdated() ||
          EventTagCreated() ||
          EventTagUpdated() ||
          EventTagDeleted() ||
          EventSettingsThemeModeChanged() ||
          EventSettingsTagsVisibilityChanged() ||
          EventSettingsDataDeletionRequested():
        break;

      case EventAccountCreated() || EventDataImported():
        final accounts = await Future.wait<List<AccountModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return accountService.getMany(page: index);
          }),
        );
        final balances = await Future.wait<List<AccountBalanceModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return accountService.getBalances(page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.canLoadMore = accounts.lastOrNull?.isNotEmpty ?? false;
          viewModel.accounts = accounts.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
          viewModel.balances = balances.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventAccountUpdated(value: final account):
        final balance = await accountService.getBalance(id: account.id);
        viewModel.setProtectedState(() {
          viewModel.accounts = List<AccountModel>.from(
            viewModel.accounts.map(
              (e) => e.id == account.id ? account.copyWith() : e,
            ),
          );
          viewModel.balances = List<AccountBalanceModel>.from(
            viewModel.balances.map((e) => e.id == balance?.id ? balance : e),
          );
        });

      case EventAccountDeleted():
        // NOTE: the length here is not updated yet hence "1"
        if (viewModel.accounts.length == 1) context.close();
        final List<List<AccountModel>> accounts = [];
        final List<List<AccountBalanceModel>> balances = [];
        int scrollPage = 0;
        do {
          accounts.add(await accountService.getMany(page: scrollPage));
          balances.add(await accountService.getBalances(page: scrollPage));
          ++scrollPage;
        } while (scrollPage <= viewModel.scrollPage &&
            (accounts.lastOrNull?.isNotEmpty ?? false));
        viewModel.setProtectedState(() {
          viewModel.scrollPage = scrollPage;
          viewModel.canLoadMore = accounts.lastOrNull?.isNotEmpty ?? false;
          viewModel.accounts = accounts.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
          viewModel.balances = balances.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventAccountBalanceExchanged(value: final accounts):
        final balance1 = await accountService.getBalance(id: accounts.$1.id);
        final balance2 = await accountService.getBalance(id: accounts.$2.id);
        viewModel.setProtectedState(() {
          viewModel.accounts = List<AccountModel>.from(
            viewModel.accounts.map((e) {
              if (e.id == accounts.$1.id) {
                return accounts.$1.copyWith();
              } else if (e.id == accounts.$2.id) {
                return accounts.$2.copyWith();
              }
              return e;
            }),
          );
          viewModel.balances = List<AccountBalanceModel>.from(
            viewModel.balances.map((e) {
              if (e.id == balance1?.id) {
                return balance1;
              } else if (e.id == balance2?.id) {
                return balance2;
              }
              return e;
            }),
          );
        });

      case EventCategoryDeleted():
        final balances = await Future.wait<List<AccountBalanceModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return accountService.getBalances(page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.balances = balances.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventTransactionCreated(value: final transaction) ||
          EventTransactionUpdated(value: final transaction) ||
          EventTransactionDeleted(value: final transaction):
        final id =
            viewModel.balances
                .where((e) => e.id == transaction.account.id)
                .firstOrNull
                ?.id;
        if (id == null) return;
        final balance = await accountService.getBalance(id: id);
        if (balance == null) return;
        viewModel.setProtectedState(() {
          viewModel.balances = List.from(
            viewModel.balances.map((e) => e.id == balance.id ? balance : e),
          );
        });

      case EventSettingsCentsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isCentsVisible = value;
        });

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isColorsVisible = value;
        });
    }
  }
}
