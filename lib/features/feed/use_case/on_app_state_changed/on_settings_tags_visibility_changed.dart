part of "../on_app_state_changed.dart";

final class _OnSettingsTagsVisibilityChanged {
  const _OnSettingsTagsVisibilityChanged();
  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventSettingsTagsVisibilityChanged event,
  ) async {
    viewModel.setProtectedState(() {
      viewModel.isTagsVisible = event.value;
    });
  }
}
