sealed class FeedEvent {}

final class FeedEventScrolledToBottom extends FeedEvent {
  final int pageIndex;

  FeedEventScrolledToBottom(this.pageIndex);
}
