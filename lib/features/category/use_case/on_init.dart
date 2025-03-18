import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/category/category.dart";

final class OnInit extends UseCase<Future<void>, CategoryViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    CategoryViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final categoryService = context.service<DomainCategoryService>();
    final transactionService = context.service<DomainTransactionService>();

    final balance = await categoryService.getBalance(id: viewModel.category.id);
    final feed = await transactionService.getMany(
      page: viewModel.scrollPage,
      categoryIds: [viewModel.category.id],
    );

    viewModel.setProtectedState(() {
      viewModel.scrollPage += 1;
      viewModel.balance = balance;
      viewModel.feed = feed;
    });
  }
}
