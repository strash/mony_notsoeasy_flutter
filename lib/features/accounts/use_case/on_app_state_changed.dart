import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/accounts/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({Event event, AccountsViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountService = context.read<DomainAccountService>();

    switch (value.event) {
      case EventCategoryCreated() ||
            EventCategoryUpdated() ||
            EventCategoryDeleted() ||
            EventTagCreated() ||
            EventTagUpdated() ||
            EventTagDeleted() ||
            EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted() ||
            EventSettingsThemeModeChanged():
        break;

      case EventAccountCreated():
        final accounts = await Future.wait<List<AccountModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return accountService.getMany(page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.canLoadMore = accounts.lastOrNull?.isNotEmpty ?? false;
          viewModel.accounts = accounts.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventAccountUpdated(value: final account):
        viewModel.setProtectedState(() {
          viewModel.accounts = List<AccountModel>.from(
            viewModel.accounts.map((e) {
              return e.id == account.id ? account.copyWith() : e;
            }),
          );
        });

      case EventAccountDeleted():
        if (viewModel.accounts.length == 1) return;
        final List<List<AccountModel>> accounts = [];
        int scrollPage = 0;
        do {
          accounts.add(await accountService.getMany(page: scrollPage++));
        } while (scrollPage <= viewModel.scrollPage &&
            (accounts.lastOrNull?.isNotEmpty ?? false));
        viewModel.setProtectedState(() {
          viewModel.scrollPage = scrollPage;
          viewModel.canLoadMore = accounts.lastOrNull?.isNotEmpty ?? false;
          viewModel.accounts = accounts.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });
    }
  }
}
