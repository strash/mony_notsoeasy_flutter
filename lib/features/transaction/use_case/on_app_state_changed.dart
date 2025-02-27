import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/domain/services/database/transaction.dart";
import "package:mony_app/features/transaction/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({TransactionViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;

    final transactionService = context.read<DomainTransactionService>();
    final accountService = context.read<DomainAccountService>();

    switch (event) {
      case EventAccountCreated() ||
          EventCategoryCreated() ||
          EventTagCreated() ||
          EventSettingsThemeModeChanged() ||
          EventSettingsTagsVisibilityChanged() ||
          EventSettingsDataDeletionRequested():
        break;

      case EventAccountUpdated(value: final account):
        if (account.id != viewModel.transaction.account.id) return;
        final balance = await accountService.getBalance(id: account.id);
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            account: account.copyWith(),
          );
          viewModel.balance = balance;
        });

      case EventAccountDeleted(value: final account):
        if (account.id != viewModel.transaction.account.id) return;
        context.close();

      case EventCategoryUpdated(value: final category):
        if (category.id != viewModel.transaction.category.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            category: category.copyWith(),
          );
        });

      case EventCategoryDeleted(value: final category):
        final id = viewModel.transaction.account.id;
        final balance = await accountService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
        });
        if (!context.mounted ||
            category.id != viewModel.transaction.category.id) {
          return;
        }
        context.close();

      case EventTransactionCreated(value: final transaction):
        if (viewModel.transaction.account.id != transaction.account.id) return;
        final id = transaction.account.id;
        final balance = await accountService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
        });

      case EventTransactionUpdated(value: final transaction):
        if (transaction.id != viewModel.transaction.id) return;
        final id = transaction.account.id;
        final balance = await accountService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.transaction = transaction.copyWith();
          viewModel.balance = balance;
        });

      case EventTransactionDeleted(value: final transaction):
        if (transaction.id != viewModel.transaction.id) return;
        context.close();

      case EventTagUpdated(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            tags: List<TagModel>.from(
              viewModel.transaction.tags.map((e) {
                return e.id == tag.id ? tag.copyWith() : e;
              }),
            ),
          );
        });

      case EventTagDeleted(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            tags: List<TagModel>.from(
              viewModel.transaction.tags.where((e) => e.id != tag.id),
            ),
          );
        });

      case EventDataImported():
        final id = viewModel.transaction.id;
        final accountId = viewModel.transaction.account.id;
        final transaction = await transactionService.getOne(id: id);
        final balance = await accountService.getBalance(id: accountId);
        viewModel.setProtectedState(() {
          if (transaction != null) viewModel.transaction = transaction;
          viewModel.balance = balance;
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
