import "package:flutter/widgets.dart";
import "package:mony_app/app/navigator/page/view_model.dart";

final class NavigatorDelegate extends RouterDelegate<Object> {
  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(Object? configuration) async {}

  @override
  Widget build(BuildContext context) {
    return const NavigatorViewModelBuilder();
  }
}
