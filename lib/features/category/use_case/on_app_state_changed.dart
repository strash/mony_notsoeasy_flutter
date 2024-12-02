import "dart:math";

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
      case EventAccountCreated() || EventCategoryCreated() || EventTagCreated():
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
        final feed = await transactionService.getMany(
          page: 0,
          categoryIds: [id],
        );
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = feed;
          viewModel.scrollPage = 0;
          viewModel.canLoadMore = true;
          viewModel.controller.jumpTo(.0);
        });

      case EventCategoryUpdated(value: final category):
        viewModel.setProtectedState(() {
          if (viewModel.category.id == category.id) {
            viewModel.category = category.copyWith();
          }
          viewModel.feed = List<TransactionModel>.from(
            viewModel.feed.map((e) {
              if (e.category.id == category.id) {
                return e.copyWith(category: category.copyWith());
              }
              return e;
            }),
          );
        });

      case EventCategoryDeleted(value: final category):
        final id = viewModel.category.id;
        if (category.id != id) return;
        context.close();

      case EventTransactionCreated(value: final transaction):
        final id = viewModel.category.id;
        if (transaction.category.id != id) return;
        final balance = await categoryService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
          viewModel.feed = viewModel.feed.merge([transaction.copyWith()]);
        });

      case EventTransactionUpdated():
        final id = viewModel.category.id;
        final balance = await categoryService.getBalance(id: id);
        final feed = await Future.wait(
          List.generate(viewModel.scrollPage + 1, (index) {
            return transactionService.getMany(page: index, categoryIds: [id]);
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
        final id = viewModel.category.id;
        if (transaction.category.id != id) return;
        final balance = await categoryService.getBalance(id: id);
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
    }
  }
}
