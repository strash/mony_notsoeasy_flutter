import "dart:ui";

sealed class TransactionFormButtonType {
  final Color color;
  final bool Function(String value) isEnabled;

  TransactionFormButtonType({required this.color, required this.isEnabled});
}

final class TransactionFormButtonTypeSymbol extends TransactionFormButtonType {
  final String value;

  TransactionFormButtonTypeSymbol({
    required super.color,
    required super.isEnabled,
    required this.value,
  });
}

final class TransactionFormButtonTypeAction extends TransactionFormButtonType {
  final String icon;

  TransactionFormButtonTypeAction({
    required super.color,
    required super.isEnabled,
    required this.icon,
  });
}
