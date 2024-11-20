import "package:mony_app/features/navbar/page/view_model.dart";

sealed class NavBarEvent {}

final class NavBarEventTabChanged extends NavBarEvent {
  final NavBarTabItem tab;

  NavBarEventTabChanged(this.tab);
}

final class NavBarEventScrollToTopRequested extends NavBarEvent {}

final class NavBarEventAddTransactionPreseed extends NavBarEvent {}
