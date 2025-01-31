part of "./categories_legend.dart";

final class _GradientTween extends Tween<(Color, Color)> {
  _GradientTween({required super.begin, required super.end});

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
