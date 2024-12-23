import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/models.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/features/accounts/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({Event event, AccountsViewModel viewModel});

final class OnAppStateCnanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final accountService = context.read<DomainAccountService>();

    switch (value.event) {
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

      case EventAccountUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventAccountDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventCategoryCreated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventCategoryUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventCategoryDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTagCreated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTagUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTagDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTransactionCreated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTransactionUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTransactionDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
