import "dart:ui";

sealed class ButtonType {
  final Color color;
  final bool Function(String value) isEnabled;

  ButtonType({required this.color, required this.isEnabled});
}

final class ButtonTypeSymbol extends ButtonType {
  final String number;

  ButtonTypeSymbol({
    required super.color,
    required super.isEnabled,
    required this.number,
  });
}

final class ButtonTypeAction extends ButtonType {
  final String icon;

  ButtonTypeAction({
    required super.color,
    required super.isEnabled,
    required this.icon,
  });
}
