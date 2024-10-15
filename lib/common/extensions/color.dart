import "dart:ui";

extension ColorEx on Color {
  String toHexadecimal() {
    final String color = value.toRadixString(16).toUpperCase();
    return "0x${color.padLeft(8, "0")}";
  }
}
