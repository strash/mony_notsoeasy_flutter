part of "../on_app_state_changed.dart";

final class _OnSettingsColorsVisibilityChanged {
  const _OnSettingsColorsVisibilityChanged();
  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventSettingsColorsVisibilityChanged event,
  ) async {
    viewModel.setProtectedState(() {
      viewModel.isColorsVisible = event.value;
    });
  }
}
