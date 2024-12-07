import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({AccountViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountService = context.read<DomainAccountService>();

    switch (event) {
      case EventAccountCreated() ||
            EventCategoryCreated() ||
            EventCategoryUpdated() ||
            EventTagCreated() ||
            EventTagUpdated() ||
            EventTagDeleted():
        break;

      case EventAccountUpdated(value: final account):
        if (viewModel.account.id != account.id) return;
        final balance = await accountService.getBalance(id: account.id);
        if (balance == null) return;
        viewModel.setProtectedState(() {
          viewModel.account = account.copyWith();
          viewModel.balance = balance;
        });

      case EventAccountDeleted(value: final account):
        if (viewModel.account.id != account.id) return;
        context.close();

      case EventCategoryDeleted():
        final id = viewModel.account.id;
        final balance = await accountService.getBalance(id: id);
        viewModel.setProtectedState(() => viewModel.balance = balance);

      case EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted():
        final id = viewModel.account.id;
        final balance = await accountService.getBalance(id: id);
        if (balance == null) return;
        viewModel.setProtectedState(() => viewModel.balance = balance);
    }
  }
}
