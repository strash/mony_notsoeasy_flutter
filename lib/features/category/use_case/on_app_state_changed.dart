import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({CategoryViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final categoryService = context.read<DomainCategoryService>();
    final transactionService = context.read<DomainTransactionService>();

    switch (event) {
      // NOTE: when a tag is created it doesn't mean that it attached to a
      // transaction so here we're doing nothing about this
      case EventAccountCreated() ||
            EventCategoryCreated() ||
            EventTagCreated() ||
            EventSettingsThemeModeChanged() ||
            EventSettingsDataDeletionRequested():
        break;

      case EventAccountUpdated(value: final account):
        final id = viewModel.category.id;
        final balance = await categoryService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              if (e.account.id == account.id) {
                return e.copyWith(account: account.copyWith());
              }
              return e;
            }),
          );
        });

      case EventAccountDeleted():
        final id = viewModel.category.id;
        final balance = await categoryService.getBalance(id: id);
        final List<List<TransactionModel>> feed = [];
        int scrollPage = 0;
        do {
          feed.add(
            await transactionService.getMany(
              page: scrollPage++,
              categoryIds: [id],
            ),
          );
        } while (scrollPage <= viewModel.scrollPage &&
            (feed.lastOrNull?.isNotEmpty ?? false));

        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.scrollPage = scrollPage;
          viewModel.canLoadMore = feed.lastOrNull?.isNotEmpty ?? false;
          viewModel.feed = feed.fold([], (prev, curr) => prev..addAll(curr));
        });

      case EventCategoryUpdated(value: final category):
        viewModel.setProtectedState(() {
          if (viewModel.category.id == category.id) {
            viewModel.category = category.copyWith();
          }
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              if (e.category.id != category.id) return e;
              return e.copyWith(category: category.copyWith());
            }),
          );
        });

      case EventCategoryDeleted(value: final category):
        if (viewModel.category.id != category.id) return;
        context.close();

      case EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted():
        final id = viewModel.category.id;
        final balance = await categoryService.getBalance(id: id);
        final feed = await Future.wait<List<TransactionModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return transactionService.getMany(page: index, categoryIds: [id]);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.canLoadMore = feed.lastOrNull?.isNotEmpty ?? false;
          viewModel.feed = feed.fold([], (prev, curr) => prev..addAll(curr));
        });

      case EventTagUpdated(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              return e.copyWith(
                tags: List<TagModel>.from(
                  e.tags.map((t) => t.id == tag.id ? tag.copyWith() : t),
                ),
              );
            }),
          );
        });

      case EventTagDeleted(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              return e.copyWith(
                tags: List<TagModel>.from(
                  e.tags.where((t) => t.id != tag.id),
                ),
              );
            }),
          );
        });

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isColorsVisible = value;
        });

      case EventSettingsCentsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isCentsVisible = value;
        });

      case EventSettingsTagsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isTagsVisible = value;
        });
    }
  }
}
