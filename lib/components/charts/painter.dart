part of "./chart.dart";

final class _Painter extends CustomPainter {
  final ChartConfig config;
  // data: [ { x, xLegend,  y: [ { value, groupBy } ] } ]
  final List<Map<String, dynamic>> data;
  final num maxValue;

  _Painter({
    required this.config,
    required this.data,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // marks
    paint.strokeWidth = 0;
    final sectionWidth = size.width / max(1, data.length);
    final width = max(10.0, sectionWidth - config.padding * 2.0);
    double barMaxHeight = size.height;
    for (final (index, value) in data.indexed) {
      // legend
      final legend = TextSpan(
        text: value["xLegend"]?.toString() ?? "",
        style: config.legendStyle,
      );
      final legendPainter = TextPainter(
        text: legend,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      legendPainter.layout(minWidth: sectionWidth);

      final legendSize = legendPainter.size;
      final left = index * sectionWidth;
      legendPainter.paint(
        canvas,
        Offset(left, size.height - legendSize.height),
      );

      final y = value["y"] as List<Map<String, dynamic>>?;
      if (y != null) {
        const minHeight = 5.0;
        canvas.save();

        // mask for mark groups
        barMaxHeight = size.height - legendSize.height - 5.0;
        final totalHeight =
            y.fold(.0, (prev, curr) => prev + (curr["value"] as num));
        final totalDisplayedHeight = max(
          minHeight,
          totalHeight.remap(.0, maxValue.toDouble(), .0, barMaxHeight),
        );
        Path clipPath = Path()
          ..moveTo(left, config.radius) // top left
          ..arcToPoint(
            Offset(left + config.radius, .0),
            radius: Radius.circular(config.radius),
          ) // top left radius
          ..lineTo(left + width - config.radius, .0) // top right
          ..arcToPoint(
            Offset(left + width, config.radius),
            radius: Radius.circular(config.radius),
          ) // top right radius
          ..lineTo(left + width, totalDisplayedHeight) // bottom right
          ..lineTo(left, totalDisplayedHeight) // bottom left
          ..close();
        // invert by vertical and offset to the right
        clipPath = clipPath.shift(
          Offset(config.padding, barMaxHeight - totalDisplayedHeight),
        );
        canvas.clipPath(clipPath);

        // mark groups
        double offset = .0;
        for (final group in y) {
          paint.color = config.groupColor(group["groupBy"]);
          final height = group["value"] as num;
          final displayedHeight = max(
            minHeight,
            height.toDouble().remap(.0, maxValue.toDouble(), .0, barMaxHeight),
          );
          Rect rect = Rect.fromLTWH(left, .0, width, displayedHeight);
          // invert by vertical and offset to the right
          rect = rect.shift(
            Offset(config.padding, barMaxHeight - offset - displayedHeight),
          );
          canvas.drawRect(rect, paint);
          offset += displayedHeight;
        }

        canvas.restore();
      }

      legendPainter.dispose();
    }

    // grid
    paint.strokeWidth = 1.0;
    paint.color = config.gridColor;
    // top line
    canvas.drawLine(Offset.zero, Offset(size.width, .0), paint);
    // bottom line
    canvas.drawLine(
      Offset(.0, barMaxHeight),
      Offset(size.width, barMaxHeight),
      paint,
    );
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return data != oldDelegate.data ||
        config != oldDelegate.config ||
        maxValue != oldDelegate.maxValue;
  }
}
