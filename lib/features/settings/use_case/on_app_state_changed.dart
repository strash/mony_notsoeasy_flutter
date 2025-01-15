import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/features.dart";

typedef _TValue = ({Event event, SettingsViewModel viewModel});

final class OnAppStateChanged extends UseCase<void, _TValue> {
  @override
  void call(BuildContext context, [_TValue? value]) {
    if (value == null) throw ArgumentError.notNull();

    final (event: event, viewModel: viewModel) = value;

    switch (event) {
      case EventAccountCreated() ||
            EventAccountUpdated() ||
            EventAccountDeleted() ||
            EventCategoryCreated() ||
            EventCategoryUpdated() ||
            EventCategoryDeleted() ||
            EventTagCreated() ||
            EventTagUpdated() ||
            EventTagDeleted() ||
            EventTransactionCreated() ||
            EventTransactionUpdated() ||
            EventTransactionDeleted():
        break;

      case EventSettingsThemeModeChanged(value: final mode):
        viewModel.setProtectedState(() {
          viewModel.mode = mode;
        });
    }
  }
}
