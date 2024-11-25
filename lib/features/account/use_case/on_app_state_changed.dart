import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({AccountViewModel viewModel, Event event});

final class OnAccountAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountService = context.read<DomainAccountService>();
    final navigator = Navigator.of(context);

    switch (event) {
      case EventAccountCreated() || EventCategoryUpdated():
        break;

      case EventAccountUpdated(value: final account):
        if (viewModel.account.id != account.id) return;
        final balances = await accountService.getBalances(ids: [account.id]);
        if (balances.isEmpty) return;
        viewModel.setProtectedState(() {
          viewModel.account = account.copyWith();
          viewModel.balance = balances.first;
        });

      case EventAccountDeleted(value: final account):
        if (viewModel.account.id != account.id) return;
        navigator.pop<void>();

      case EventCategoryDeleted():
        final id = viewModel.account.id;
        final balances = await accountService.getBalances(ids: [id]);
        viewModel.setProtectedState(() {
          viewModel.balance = balances.first;
        });

      case EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted():
        final balances = await accountService.getBalances(
          ids: [viewModel.account.id],
        );
        if (balances.isEmpty) return;
        viewModel.setProtectedState(() => viewModel.balance = balances.first);
    }
  }
}
