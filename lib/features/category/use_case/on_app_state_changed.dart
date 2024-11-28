import "dart:math";

import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
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
    final navigator = Navigator.of(context);

    switch (event) {
      case EventAccountCreated():
        final id = viewModel.category.id;
        final balance = await categoryService.getBalance(id: id);
        viewModel.setProtectedState(() {
          viewModel.balance = balance;
        });

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

      case EventCategoryCreated():
        break;

      case EventCategoryUpdated(value: final category):
        viewModel.setProtectedState(() {
          viewModel.category = category.copyWith();
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
        navigator.pop<void>();

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
    }
  }
}
