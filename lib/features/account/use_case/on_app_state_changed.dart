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
      case EventCategoryCreated() ||
          EventCategoryUpdated() ||
          EventTagCreated() ||
          EventTagUpdated() ||
          EventTagDeleted() ||
          EventSettingsThemeModeChanged() ||
          EventSettingsCentsVisibilityChanged() ||
          EventSettingsTagsVisibilityChanged() ||
          EventSettingsDataDeletionRequested():
        break;

      case EventAccountCreated():
        final count = await accountService.count();
        viewModel.setProtectedState(() {
          viewModel.accountsCount = count;
        });

      case EventAccountUpdated(value: final account):
        if (viewModel.account.id != account.id) return;
        final balance = await accountService.getBalance(id: account.id);
        viewModel.setProtectedState(() {
          viewModel.account = account.copyWith();
          if (balance != null) viewModel.balance = balance;
        });

      case EventAccountDeleted(value: final account):
        if (viewModel.account.id != account.id) {
          final count = await accountService.count();
          viewModel.setProtectedState(() {
            viewModel.accountsCount = count;
          });
        } else {
          context.close();
        }

      case EventAccountBalanceExchanged(value: final accounts):
        AccountModel? account;
        if (viewModel.account.id == accounts.$1.id) {
          account = accounts.$1;
        } else if (viewModel.account.id == accounts.$2.id) {
          account = accounts.$2;
        }
        if (account == null) return;
        final balance = await accountService.getBalance(id: account.id);
        viewModel.setProtectedState(() {
          viewModel.account = account!.copyWith();
          if (balance != null) viewModel.balance = balance;
        });

      case EventCategoryDeleted() ||
          EventTransactionCreated() ||
          EventTransactionUpdated() ||
          EventTransactionDeleted():
        final id = viewModel.account.id;
        final balance = await accountService.getBalance(id: id);
        if (balance == null) return;
        viewModel.setProtectedState(() => viewModel.balance = balance);

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isColorsVisible = value;
        });

      case EventDataImported():
        final id = viewModel.account.id;
        final account = await accountService.getOne(id: id);
        final balance = await accountService.getBalance(id: id);
        viewModel.setProtectedState(() {
          if (account != null) viewModel.account = account;
          if (balance != null) viewModel.balance = balance;
        });
    }
  }
}
