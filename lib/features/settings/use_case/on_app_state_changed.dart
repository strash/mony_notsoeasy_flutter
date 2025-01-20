import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/features.dart";

typedef _TValue = ({Event event, SettingsViewModel viewModel});

final class OnAppStateChanged extends UseCase<void, _TValue> {
  @override
  void call(BuildContext context, [_TValue? value]) {
    if (value == null) throw ArgumentError.notNull();

    final (:event, :viewModel) = value;

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
            EventTransactionDeleted() ||
            EventSettingsDataDeletionRequested():
        break;

      case EventSettingsThemeModeChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.themeMode = value;
        });

      case EventSettingsColorsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isColorsVisible = value;
        });

      case EventSettingsCentsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isCentsVisible = value;
        });

      case EventSettingsTagsVisibilityChanged(:final value):
        viewModel.setProtectedState(() {
          viewModel.isTagsVisible = value;
        });
    }
  }
}
