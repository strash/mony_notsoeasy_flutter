import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/page.dart";

final class OnScroll extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [dynamic _]) {
    final viewModel = context.viewModel<FeedViewModel>();
    final controller = viewModel.scrollController;
    if (!controller.hasClients ||
        !controller.position.hasPixels ||
        !controller.position.haveDimensions ||
        controller.position.userScrollDirection != ScrollDirection.reverse) {
      return;
    }
    final extent = controller.position.extentAfter;
    if (extent < 400.0) {
      viewModel.subject.add(FeedEventScrolledToBottom());
    }
  }
}
