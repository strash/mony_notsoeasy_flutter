import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/search/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({Event event, SearchViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;

    // TODO: обновлять данные поисковых запросов

    switch (event) {
      case EventAccountCreated():
        final counts = await _updateCounts(context);
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventAccountUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();

      case EventAccountDeleted():
        final counts = await _updateCounts(context);
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventCategoryCreated():
        final counts = await _updateCounts(context);
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventCategoryUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();

      case EventCategoryDeleted():
        final counts = await _updateCounts(context);
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventTagCreated():
        final counts = await _updateCounts(context);
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventTagUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();

      case EventTagDeleted():
        final counts = await _updateCounts(context);
        viewModel.setProtectedState(() => viewModel.counts = counts);

      case EventTransactionCreated():
        // TODO: Handle this case.
        throw UnimplementedError();

      case EventTransactionUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();

      case EventTransactionDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<Map<ESearchPage, int>> _updateCounts(BuildContext context) async {
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    return {
      for (final page in ESearchPage.values)
        page: await switch (page) {
          ESearchPage.accounts => accountService.count(),
          ESearchPage.categories => categoryService.count(),
          ESearchPage.tags => tagService.count(),
        },
    };
  }
}
