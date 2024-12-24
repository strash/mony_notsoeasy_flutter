import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/categories/page/view_model.dart";
import "package:provider/provider.dart";

typedef _TValue = ({Event event, CategoriesViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;
    final categoryService = context.read<DomainCategoryService>();

    switch (event) {
      case EventAccountCreated() ||
            EventAccountUpdated() ||
            EventAccountDeleted() ||
            EventTagCreated() ||
            EventTagUpdated() ||
            EventTagDeleted() ||
            EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted():
        break;

      case EventCategoryCreated():
        final categories = await Future.wait<List<CategoryModel>>(
          List.generate(viewModel.scrollPage + 1, (index) {
            return categoryService.getMany(page: index);
          }),
        );
        viewModel.setProtectedState(() {
          viewModel.canLoadMore = categories.lastOrNull?.isNotEmpty ?? false;
          viewModel.categories = categories.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });

      case EventCategoryUpdated(value: final category):
        viewModel.setProtectedState(() {
          viewModel.categories = List<CategoryModel>.from(
            viewModel.categories.map((e) {
              return e.id == category.id ? category.copyWith() : e;
            }),
          );
        });

      case EventCategoryDeleted():
        final List<List<CategoryModel>> categories = [];
        int scrollPage = 0;
        do {
          categories.add(await categoryService.getMany(page: scrollPage++));
        } while (scrollPage <= viewModel.scrollPage &&
            (categories.lastOrNull?.isNotEmpty ?? false));
        viewModel.setProtectedState(() {
          viewModel.scrollPage = scrollPage;
          viewModel.canLoadMore = categories.lastOrNull?.isNotEmpty ?? false;
          viewModel.categories = categories.fold([], (prev, curr) {
            return prev..addAll(curr);
          });
        });
    }
  }
}
