import "package:flutter/widgets.dart";

final class SearchGradientTween extends Tween<(Color, Color)> {
  SearchGradientTween({required super.begin, required super.end});

  @override
  (Color, Color) lerp(double t) {
    const opaque = Color(0xFFFFFFFF);
    final (begin, end) = (this.begin, this.end);
    if (begin == null || end == null) return (opaque, opaque);
    return (
      Color.lerp(begin.$1, end.$1, t) ?? opaque,
      Color.lerp(begin.$2, end.$2, t) ?? opaque,
    );
  }
}
