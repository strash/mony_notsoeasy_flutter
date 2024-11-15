import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/feed/page/view_model.dart";

final class OnPageChanged extends UseCase<void, int> {
  @override
  void call(BuildContext context, [int? pageIndex]) {
    if (pageIndex == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<FeedViewModel>();

    final scroll = viewModel.scrollControllers.elementAt(pageIndex);
    if (!scroll.isReady) return;
    scroll.jumpTo(viewModel.scrollPositions.elementAt(pageIndex));
  }
}
