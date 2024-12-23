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

    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();

    final viewModel = value.viewModel;

    // TODO: обновлять счетчики при добавлении/удалении айтемов
    // TODO: обновлять данные поисковых запросов

    switch (value.event) {
      case EventAccountCreated():
        final count = await accountService.count();
        viewModel.setProtectedState(() {
          viewModel.pageCounts[ESearchPage.accounts] = count;
        });
      case EventAccountUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventAccountDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventCategoryCreated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventCategoryUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventCategoryDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTagCreated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTagUpdated():
        // TODO: Handle this case.
        throw UnimplementedError();
      case EventTagDeleted():
        // TODO: Handle this case.
        throw UnimplementedError();
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
}
