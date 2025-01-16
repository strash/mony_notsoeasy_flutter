part of "../on_app_state_changed.dart";

final class _OnSettingsCentsVisibilityChanged {
  const _OnSettingsCentsVisibilityChanged();
  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventSettingsCentsVisibilityChanged event,
  ) async {
    viewModel.setProtectedState(() {
      viewModel.isCentsVisible = event.value;
    });
  }
}
