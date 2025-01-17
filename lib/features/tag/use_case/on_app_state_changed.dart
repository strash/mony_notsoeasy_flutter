import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/domain/services/database/database.dart";
import "package:mony_app/features/tag/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({TagViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final tagService = context.read<DomainTagService>();
    final transactionService = context.read<DomainTransactionService>();

    switch (event) {
      case EventAccountCreated() ||
            EventCategoryCreated() ||
            EventTagCreated() ||
            EventSettingsThemeModeChanged() ||
            EventSettingsDefaultTransactionTypeChanged():
        break;

      case EventAccountUpdated(value: final account):
        final id = viewModel.tag.id;
        final balance = await tagService.getBalance(id: id);
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

      case EventAccountDeleted() || EventCategoryDeleted():
        final id = viewModel.tag.id;
        final balance = await tagService.getBalance(id: id);
        final List<List<TransactionModel>> feed = [];
        int scrollPage = 0;
        do {
          feed.add(
            await transactionService.getMany(page: scrollPage++, tagIds: [id]),
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
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              if (e.category.id != category.id) return e;
              return e.copyWith(category: category.copyWith());
            }),
          );
        });

      case EventTransactionCreated(value: final transaction):
        final id = viewModel.tag.id;
        if (transaction.tags.every((e) => e.id != id)) return;
        final balance = await tagService.getBalance(id: id);
        final feed = await Future.wait(
          List.generate(viewModel.scrollPage + 1, (index) {
            return transactionService.getMany(page: index, tagIds: [id]);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.canLoadMore = feed.lastOrNull?.isNotEmpty ?? false;
          viewModel.feed = feed.fold([], (prev, curr) => prev..addAll(curr));
        });

      case EventTransactionUpdated():
        final id = viewModel.tag.id;
        final balance = await tagService.getBalance(id: id);
        // NOTE: after update the transaction could be without the tag so we're
        // just updating the whole thing
        final feed = await Future.wait(
          List.generate(viewModel.scrollPage + 1, (index) {
            return transactionService.getMany(page: index, tagIds: [id]);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.canLoadMore = feed.lastOrNull?.isNotEmpty ?? false;
          viewModel.feed = feed.fold([], (prev, curr) => prev..addAll(curr));
        });

      case EventTransactionDeleted(value: final transaction):
        final id = viewModel.tag.id;
        if (transaction.tags.every((e) => e.id != id)) return;
        final balance = await tagService.getBalance(id: id);
        final feed = await Future.wait(
          List.generate(viewModel.scrollPage + 1, (index) {
            return transactionService.getMany(page: index, tagIds: [id]);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.canLoadMore = feed.lastOrNull?.isNotEmpty ?? false;
          viewModel.feed = feed.fold([], (prev, curr) => prev..addAll(curr));
        });

      case EventTagUpdated(value: final tag):
        viewModel.setProtectedState(() {
          if (viewModel.tag.id == tag.id) viewModel.tag = tag.copyWith();
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
        if (viewModel.tag.id == tag.id) {
          context.close();
          return;
        }
        viewModel.setProtectedState(() {
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              return e.copyWith(
                tags: List<TagModel>.from(e.tags.where((t) => t.id != tag.id)),
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
