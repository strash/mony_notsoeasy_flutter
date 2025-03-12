import "dart:ui";

extension OffsetEx on Offset {
  Offset add(Offset other) {
    return Offset(dx + other.dx, dy + other.dy);
  }

  Offset addDx(Offset other) {
    return Offset(dx + other.dx, dy);
  }

  Offset addDy(Offset other) {
    return Offset(dx, dy + other.dy);
  }
}
