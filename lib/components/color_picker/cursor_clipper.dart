part of "./component.dart";

final class _CursorClipper extends CustomClipper<Path> {
  final EdgeInsets padding;
  final double radius;

  const _CursorClipper({
    required this.padding,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    final pathFrom = Path();
    final pathTo = Path();
    final rectFrom = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final rectTo = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.horizontal,
      size.height - padding.vertical,
    );
    final rrectTo = RRect.fromRectAndRadius(
      rectTo,
      SmoothRadius(
        cornerRadius: radius,
        cornerSmoothing: 1.0,
      ),
    );
    pathFrom.addRect(rectFrom);
    pathTo.addRRect(rrectTo);
    return Path.combine(PathOperation.difference, pathFrom, pathTo);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
