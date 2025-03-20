import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/painting.dart";

extension Smooth on SmoothRectangleBorder {
  static OutlinedBorder border(
    double radius, [
    BorderSide side = BorderSide.none,
  ]) {
    return SmoothRectangleBorder(
      side: side,
      borderRadius: SmoothBorderRadius.all(
        SmoothRadius(cornerRadius: radius, cornerSmoothing: 0.7),
      ),
    );
  }
}
