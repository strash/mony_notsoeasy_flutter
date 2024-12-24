import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/domain/services/database/database.dart";
import "package:mony_app/features/tags/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({Event event, TagsViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final tagService = context.read<DomainTagService>();

    switch (event) {
      case EventAccountCreated() ||
            EventAccountUpdated() ||
            EventAccountDeleted() ||
            EventCategoryCreated() ||
            EventCategoryUpdated() ||
            EventCategoryDeleted() ||
            EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted():
        break;

      case EventTagCreated():
        final tags = await Future.wait<List<TagModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return tagService.getMany(page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.canLoadMore = tags.lastOrNull?.isNotEmpty ?? false;
          viewModel.tags = tags.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventTagUpdated(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.tags = List<TagModel>.from(
            viewModel.tags.map((e) {
              return e.id == tag.id ? tag.copyWith() : e;
            }),
          );
        });

      case EventTagDeleted():
        final List<List<TagModel>> tags = [];
        int scrollPage = 0;
        do {
          tags.add(await tagService.getMany(page: scrollPage++));
        } while (scrollPage <= viewModel.scrollPage &&
            (tags.lastOrNull?.isNotEmpty ?? false));
        viewModel.setProtectedState(() {
          viewModel.scrollPage = scrollPage;
          viewModel.canLoadMore = tags.lastOrNull?.isNotEmpty ?? false;
          viewModel.tags = tags.fold([], (prev, curr) => prev..addAll(curr));
        });
    }
  }
}
