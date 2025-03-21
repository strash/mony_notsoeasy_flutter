import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/tag/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, TagViewModel> {
  @override
  Future<void> call(BuildContext context, [TagViewModel? viewModel]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final tagService = context.service<DomainTagService>();
    final transactionService = context.service<DomainTransactionService>();

    final balance = await tagService.getBalance(id: viewModel.tag.id);
    final feed = await transactionService.getMany(
      page: viewModel.scrollPage,
      tagIds: [viewModel.tag.id],
    );

    viewModel.setProtectedState(() {
      viewModel.scrollPage += 1;
      viewModel.balance = balance;
      viewModel.feed = feed;
    });
  }
}
