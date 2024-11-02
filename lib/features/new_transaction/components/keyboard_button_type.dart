import "dart:ui";

sealed class ButtonType {
  final Color color;

  ButtonType({required this.color});
}

final class ButtonTypeSymbol extends ButtonType {
  final String number;

  ButtonTypeSymbol({required super.color, required this.number});
}

final class ButtonTypeAction extends ButtonType {
  final String icon;

  ButtonTypeAction({required super.color, required this.icon});
}
