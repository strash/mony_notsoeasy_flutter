import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/feed/feed.dart";
import "package:provider/provider.dart";

part "./on_app_state_changed/on_account_created.dart";
part "./on_app_state_changed/on_account_deleted.dart";
part "./on_app_state_changed/on_account_updated.dart";
part "./on_app_state_changed/on_category_updated.dart";
part "./on_app_state_changed/on_category_deleted.dart";
part "./on_app_state_changed/on_transaction_created.dart";
part "./on_app_state_changed/on_transaction_deleted.dart";
part "./on_app_state_changed/on_transaction_updated.dart";
part "./on_app_state_changed/on_tag_updated.dart";
part "./on_app_state_changed/on_tag_deleted.dart";

typedef _TValue = ({FeedViewModel viewModel, Event event});

// TODO: 2. При добавлении второго счета сначала добавить экран со всеми счетами
// в начало списка, прыгнуть на второй экран (экран со счетом, на котором
// находились), добавить экран с новым счетом в конец и потом уже анимировать на
// него. Чтобы не было видно подмены счетов на первом экране

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final (:viewModel, :event) = value;

    switch (event) {
      case EventCategoryCreated() || EventTagCreated():
        break;

      case EventAccountCreated():
        const _OnAccountCreated().call(context, viewModel, event);

      case EventAccountUpdated():
        const _OnAccountUpdated().call(context, viewModel, event);

      case EventAccountDeleted():
        const _OnAccountDeleted().call(context, viewModel, event);

      case EventCategoryUpdated():
        const _OnCategoryUpdated().call(context, viewModel, event);

      case EventCategoryDeleted():
        const _OnCategoryDeleted().call(context, viewModel, event);

      case EventTransactionCreated():
        const _OnTransactionCreated().call(context, viewModel, event);

      case EventTransactionUpdated():
        const _OnTransactionUpdated().call(context, viewModel, event);

      case EventTransactionDeleted():
        const _OnTransactionDeleted().call(context, viewModel, event);

      case EventTagUpdated():
        const _OnTagUpdated().call(context, viewModel, event);

      case EventTagDeleted():
        const _OnTagDeleted().call(context, viewModel, event);
    }
  }
}
