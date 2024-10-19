import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/page/page.dart";
import "package:mony_app/features/navbar/use_case/on_pop_tabs_to_root_requested.dart";

final class OnTabChangeRequested extends UseCase<void, NavBarTabItem> {
  @override
  void call(BuildContext context, [NavBarTabItem? value]) {
    if (value == null) throw ArgumentError.notNull();
    final viewModel = context.viewModel<NavBarViewModel>();
    final popTabToRoot = viewModel<OnPopTabsToRootRequested>();

    if (viewModel.currentTab == value) {
      popTabToRoot(context, value);
    } else {
      viewModel.currentTab = value;
      viewModel.subject.add(value);
    }
  }
}
