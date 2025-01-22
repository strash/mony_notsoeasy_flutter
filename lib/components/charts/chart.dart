import "package:flutter/widgets.dart";
import "package:mony_app/components/charts/bar_mark.dart";
import "package:mony_app/components/charts/config.dart";
import "package:mony_app/components/charts/ruler.dart";

final class ChartComponent extends StatelessWidget {
  final List<ChartBarMarkComponent> data;
  final List<ChartRulerComponent> rulers;
  final ChartConfig config;

  const ChartComponent({
    super.key,
    required this.data,
    this.rulers = const [],
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(
        config: config,
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final ChartConfig config;

  _Painter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = 1.0;
    paint.color = config.gridColor;
    canvas.drawLine(Offset.zero, Offset(size.width, .0), paint);
    canvas.drawLine(
      Offset(.0, size.height),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
