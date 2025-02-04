import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/stats/page/view_model.dart";
import "package:mony_app/features/stats/use_case/on_init.dart";
import "package:provider/provider.dart";

typedef _TValue = ({StatsViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final (from, to) = viewModel.exclusiveDateRange;
    final accountService = context.read<DomainAccountService>();
    final transactionService = context.read<DomainTransactionService>();

    switch (event) {
      case EventCategoryCreated() ||
            EventTagCreated() ||
            EventSettingsThemeModeChanged() ||
            EventSettingsDataDeletionRequested():
        break;

      case EventAccountCreated(value: final account):
        viewModel.setProtectedState(() {
          viewModel.accounts = viewModel.accounts.merge([account]);
        });

      case EventAccountUpdated(value: final account):
        if (viewModel.accountController.value?.id == account.id) {
          viewModel.accountController.value = account;
          final balance = await accountService.getBalanceForDateRange(
            id: account.id,
            from: from,
            to: to,
          );
          viewModel.balance = balance;
          viewModel.transactions = List<TransactionModel>.from(
            viewModel.transactions.map((e) {
              return e.copyWith(account: account.copyWith());
            }),
          );
        }
        viewModel.setProtectedState(() {
          viewModel.accounts = viewModel.accounts.merge([account]);
        });

      case EventAccountDeleted(value: final account):
        if (viewModel.accounts.length == 1) return;
        viewModel.accounts = List.from(
          viewModel.accounts.where((e) => e.id != account.id),
        );
        if (viewModel.accountController.value?.id == account.id) {
          viewModel.accountController.value = viewModel.accounts.firstOrNull;
          if (viewModel.accountController.value != null) {
            final balance = await accountService.getBalanceForDateRange(
              id: viewModel.accountController.value!.id,
              from: from,
              to: to,
            );
            final transactions = await transactionService.getRange(
              from: from,
              to: to,
              accountId: viewModel.accountController.value!.id,
              transactionType: viewModel.activeTransactionType,
            );
            viewModel.balance = balance;
            viewModel.transactions = transactions;
          }
        }
        viewModel.setProtectedState(() {});
        viewModel.resetCategoryScrollController();

      case EventCategoryUpdated(value: final category):
        viewModel.setProtectedState(() {
          viewModel.transactions = List.from(
            viewModel.transactions.map((e) {
              return e.category.id == category.id
                  ? e.copyWith(category: category.copyWith())
                  : e;
            }),
          );
        });
        viewModel.resetCategoryScrollController();

      case EventCategoryDeleted(value: final category):
        final balance = await accountService.getBalanceForDateRange(
          id: viewModel.accountController.value!.id,
          from: from,
          to: to,
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.transactions = List.from(
            viewModel.transactions.where((e) => e.category.id != category.id),
          );
        });
        viewModel.resetCategoryScrollController();

      case EventTagUpdated(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.transactions = List.from(
            viewModel.transactions.map((e) {
              return e.copyWith(
                tags: List.from(
                  e.tags.map((t) => t.id == tag.id ? tag.copyWith() : t),
                ),
              );
            }),
          );
        });

      case EventTagDeleted(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.transactions = List.from(
            viewModel.transactions.map((e) {
              return e.copyWith(
                tags: List.from(e.tags.where((t) => t.id == tag.id)),
              );
            }),
          );
        });

      case EventTransactionCreated(value: final transaction):
        if (transaction.account.id != viewModel.accountController.value?.id ||
            from.isAfter(transaction.date) ||
            to.isBefore(transaction.date)) {
          return;
        }
        final balance = await accountService.getBalanceForDateRange(
          id: viewModel.accountController.value!.id,
          from: from,
          to: to,
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.transactions = viewModel.transactions.merge([transaction]);
        });
        viewModel.resetCategoryScrollController();

      case EventTransactionUpdated(value: final transaction):
        if (transaction.account.id != viewModel.accountController.value?.id ||
            from.isAfter(transaction.date) ||
            to.isBefore(transaction.date)) {
          return;
        }
        final balance = await accountService.getBalanceForDateRange(
          id: viewModel.accountController.value!.id,
          from: from,
          to: to,
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.transactions = List.from(
            viewModel.transactions.map((e) {
              return e.id == transaction.id ? transaction.copyWith() : e;
            }),
          );
        });
        viewModel.resetCategoryScrollController();

      case EventTransactionDeleted(value: final transaction):
        if (transaction.account.id != viewModel.accountController.value?.id ||
            from.isAfter(transaction.date) ||
            to.isBefore(transaction.date)) {
          return;
        }
        final balance = await accountService.getBalanceForDateRange(
          id: viewModel.accountController.value!.id,
          from: from,
          to: to,
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.transactions = List.from(
            viewModel.transactions.where((e) => e.id != transaction.id),
          );
        });
        viewModel.resetCategoryScrollController();

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() => viewModel.isColorsVisible = value);

      case EventSettingsCentsVisibilityChanged(:final value):
        viewModel.setProtectedState(() => viewModel.isCentsVisible = value);

      case EventSettingsTagsVisibilityChanged(:final value):
        viewModel.setProtectedState(() => viewModel.isTagsVisible = value);

      case EventDataImported():
        OnInit().call(context, viewModel);
    }
  }
}
