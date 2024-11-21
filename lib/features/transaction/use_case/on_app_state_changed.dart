import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/transaction/page/view_model.dart";

typedef _TValue = ({TransactionViewModel viewModel, Event event});

final class OnTransactionAppStateChanged
    extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final navigator = Navigator.of(context);

    switch (event) {
      case EventAccountCreated() || EventTransactionCreated():
        break;
      case EventAccountUpdated(value: final account):
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            account: account.copyWith(),
          );
        });
      case EventTransactionUpdated(:final value):
        if (value.id == viewModel.transaction.id) {
          viewModel.setProtectedState(() {
            viewModel.transaction = value.copyWith();
          });
        }
      // TODO: слушать app events на удаление счета, категории и
      // закрывать экран, если удален счет или категория
      case final EventTransactionDeleted event:
        if (event.value.id == viewModel.transaction.id) navigator.pop();
    }
  }
}
