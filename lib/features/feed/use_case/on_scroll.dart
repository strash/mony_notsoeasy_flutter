import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/page.dart";

typedef TOnScrollValue = ({FeedViewModel viewModel, int pageIndex});

final class OnScroll extends UseCase<void, TOnScrollValue> {
  @override
  void call(BuildContext context, [TOnScrollValue? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = value.viewModel;
    final controller = viewModel.scrollControllers.elementAt(value.pageIndex);

    if (!controller.isReady) return;

    viewModel.scrollPositions[value.pageIndex] = controller.position.pixels;

    final extent = controller.position.extentAfter;
    final direction = controller.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && extent < 400.0) {
      viewModel.subject.add(FeedEventScrolledToBottom(value.pageIndex));
    }
  }
}
