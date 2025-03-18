import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/tag/page/view_model.dart";

final class OnDataFetched extends UseCase<Future<void>, TagViewModel> {
  @override
  Future<void> call(BuildContext context, [TagViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();
    if (!viewModel.canLoadMore) return;

    final transactionService = context.service<DomainTransactionService>();

    final feed = await transactionService.getMany(
      page: viewModel.scrollPage,
      tagIds: [viewModel.tag.id],
    );

    viewModel.setProtectedState(() {
      viewModel.scrollPage += 1;
      viewModel.canLoadMore = feed.isNotEmpty;
      viewModel.feed = viewModel.feed.merge(feed);
    });
  }
}
