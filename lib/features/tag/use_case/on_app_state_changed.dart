import "dart:math";

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
      case EventAccountCreated() || EventCategoryCreated() || EventTagCreated():
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
        final feed = await transactionService.getMany(page: 0, tagIds: [id]);
        if (!viewModel.context.mounted) return;
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = feed;
          viewModel.scrollPage = 0;
          viewModel.canLoadMore = true;
          if (viewModel.controller.isReady) viewModel.controller.jumpTo(.0);
        });

      case EventCategoryUpdated(value: final category):
        viewModel.setProtectedState(() {
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              if (e.category.id == category.id) {
                return e.copyWith(category: category.copyWith());
              }
              return e;
            }),
          );
        });

      case EventTransactionCreated(value: final transaction):
        final id = viewModel.tag.id;
        if (transaction.tags.every((e) => e.id != id)) return;
        final balance = await tagService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = viewModel.feed.merge([transaction.copyWith()]);
        });

      case EventTransactionUpdated():
        final id = viewModel.tag.id;
        final balance = await tagService.getBalance(id: id);
        final feed = await Future.wait(
          List.generate(viewModel.scrollPage + 1, (index) {
            return transactionService.getMany(page: index, tagIds: [id]);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = feed.fold<List<TransactionModel>>([], (prev, curr) {
            return [...prev, ...curr];
          });
          viewModel.canLoadMore = true;
        });

      case EventTransactionDeleted(value: final transaction):
        final id = viewModel.tag.id;
        if (transaction.tags.every((e) => e.id != id)) return;
        final balance = await tagService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.where((e) => e.id != transaction.id),
          );
          viewModel.canLoadMore = true;
          viewModel.scrollPage = max(0, viewModel.scrollPage - 1);
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
        } else {
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
        }
    }
  }
}
