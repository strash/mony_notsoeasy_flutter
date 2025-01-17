import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/tag.dart";
import "package:mony_app/features/transaction/page/view_model.dart";

typedef _TValue = ({TransactionViewModel viewModel, Event event});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;

    switch (event) {
      case EventAccountCreated() ||
            EventCategoryCreated() ||
            EventTagCreated() ||
            EventTransactionCreated() ||
            EventSettingsThemeModeChanged() ||
            EventSettingsCentsVisibilityChanged() ||
            EventSettingsTagsVisibilityChanged() ||
            EventSettingsDefaultTransactionTypeChanged():
        break;

      case EventAccountUpdated(value: final account):
        if (account.id != viewModel.transaction.account.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            account: account.copyWith(),
          );
        });

      case EventAccountDeleted(value: final account):
        if (account.id != viewModel.transaction.account.id) return;
        context.close();

      case EventCategoryUpdated(value: final category):
        if (category.id != viewModel.transaction.category.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            category: category.copyWith(),
          );
        });

      case EventCategoryDeleted(value: final category):
        if (category.id != viewModel.transaction.category.id) return;
        context.close();

      case EventTransactionUpdated(value: final transaction):
        if (transaction.id != viewModel.transaction.id) return;
        viewModel.setProtectedState(() {
          viewModel.transaction = transaction.copyWith();
        });

      case EventTransactionDeleted(value: final transaction):
        if (transaction.id != viewModel.transaction.id) return;
        context.close();

      case EventTagUpdated(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            tags: List<TagModel>.from(
              viewModel.transaction.tags.map((e) {
                return e.id == tag.id ? tag.copyWith() : e;
              }),
            ),
          );
        });

      case EventTagDeleted(value: final tag):
        viewModel.setProtectedState(() {
          viewModel.transaction = viewModel.transaction.copyWith(
            tags: List<TagModel>.from(
              viewModel.transaction.tags.where((e) => e.id != tag.id),
            ),
          );
        });

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isColorsVisible = value;
        });
    }
  }
}
