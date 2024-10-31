import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/page.dart";

typedef TOnTopOfScreenPressedValue = ({
  ScrollController scrollController,
  TapUpDetails details,
});

final class OnTopOfScreenPressed
    extends UseCase<void, TOnTopOfScreenPressedValue> {
  @override
  void call(BuildContext context, [TOnTopOfScreenPressedValue? value]) {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<NavbarViewModel>();

    if (value.details.localPosition.dy < 70) {
      viewModel.returnToTop(value.scrollController);
    }
  }
}
