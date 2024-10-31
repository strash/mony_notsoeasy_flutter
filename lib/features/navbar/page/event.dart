import "package:mony_app/features/navbar/page/view_model.dart";

sealed class NavbarEvent {}

final class NavbarEventTabChanged extends NavbarEvent {
  final NavbarTabItem tab;

  NavbarEventTabChanged(this.tab);
}

final class NavbarEventScrollToTopRequested extends NavbarEvent {}
