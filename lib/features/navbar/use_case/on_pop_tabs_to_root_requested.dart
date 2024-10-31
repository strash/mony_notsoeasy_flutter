import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/navbar/navbar.dart";

final class OnPopTabsToRootRequested extends UseCase<void, NavbarTabItem> {
  @override
  void call(BuildContext context, [NavbarTabItem? value]) {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<NavbarViewModel>();
    final key = viewModel.getNavigatorTabKey(value);
    final navigatorState = key.currentState;
    if (navigatorState == null) return;
    switch (navigatorState.canPop()) {
      // закрываем все экраны в текущем табе до первого
      case true:
        navigatorState.popUntil((route) => route.isFirst);
      // если нечего закрывать, то скролим наверх
      case false:
        viewModel.subject.add(NavbarEventScrollToTopRequested());
    }
  }
}
