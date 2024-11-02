import "dart:ui";

extension SizeEx on Size {
  Size add(Size other) {
    return Size(width + other.width, height + other.height);
  }

  Size addWidth(Size other) {
    return Size(width + other.width, height);
  }

  Size addHeight(Size other) {
    return Size(width, height + other.height);
  }
}
