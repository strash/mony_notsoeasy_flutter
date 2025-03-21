import "package:mony_app/features/navbar/page/view_model.dart";

sealed class NavBarEvent {}

final class NavBarEventTabChanged extends NavBarEvent {
  final ENavBarTabItem tab;

  NavBarEventTabChanged(this.tab);
}

final class NavBarEventScrollToTopRequested extends NavBarEvent {}

final class NavBarEventAddTransactionPressed extends NavBarEvent {}
