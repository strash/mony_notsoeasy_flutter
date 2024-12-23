import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/accounts/accounts.dart";
import "package:provider/provider.dart";

final class OnDataFetchRequested
    extends UseCase<Future<void>, AccountsViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    AccountsViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();
    if (!viewModel.canLoadMore) return;

    final accountService = context.read<DomainAccountService>();

    final accounts = await accountService.getMany(page: viewModel.scrollPage);

    viewModel.setProtectedState(() {
      viewModel.scrollPage += 1;
      viewModel.canLoadMore = accounts.isNotEmpty;
      viewModel.accounts = viewModel.accounts.merge(accounts);
    });
  }
}
