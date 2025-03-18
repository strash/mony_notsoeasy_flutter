import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/tags/page/view_model.dart";

final class OnDataFetchRequested extends UseCase<Future<void>, TagsViewModel> {
  @override
  Future<void> call(BuildContext context, [TagsViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();
    if (!viewModel.canLoadMore) return;

    final tagsService = context.service<DomainTagService>();

    final tags = await tagsService.getMany(page: viewModel.scrollPage);

    viewModel.setProtectedState(() {
      viewModel.scrollPage += 1;
      viewModel.canLoadMore = tags.isNotEmpty;
      viewModel.tags = viewModel.tags.merge(tags);
    });
  }
}
