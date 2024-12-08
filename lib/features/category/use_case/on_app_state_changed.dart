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
          viewModel.feed = feed.fold([], (prev, curr) => prev..addAll(curr));
          viewModel.canLoadMore = true;
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
