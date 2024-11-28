import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/transaction/page/view_model.dart";

typedef _TValue = ({TransactionViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final navigator = Navigator.of(context);

    switch (event) {
      case EventAccountCreated() ||
            EventCategoryCreated() ||
            EventTransactionCreated():
        break;

      case EventAccountUpdated(value: final account):
        if (account.id != viewModel.transaction.account.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            account: account.copyWith(),
          );
        });

      case EventAccountDeleted(value: final account):
        if (account.id != viewModel.transaction.account.id) return;
        navigator.pop<void>();

      case EventCategoryUpdated(value: final category):
        if (category.id != viewModel.transaction.category.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            category: category.copyWith(),
          );
        });

      case EventCategoryDeleted(value: final category):
        if (category.id != viewModel.transaction.category.id) return;
        navigator.pop<void>();

      case EventTransactionUpdated(value: final transaction):
        if (transaction.id != viewModel.transaction.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = transaction.copyWith();
        });

      case EventTransactionDeleted(value: final transaction):
        if (transaction.id != viewModel.transaction.id) return;
        navigator.pop<void>();
    }
  }
}
