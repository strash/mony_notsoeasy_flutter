part of "../on_app_state_changed.dart";

final class _OnDataImported {
  const _OnDataImported();
  Future<void> call(
    BuildContext context,
    FeedViewModel viewModel,
    EventDataImported event,
  ) async {
    OnInit().call(context, viewModel);
  }
}
