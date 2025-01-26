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

    // vertical legend
    final maxValueLegend = TextSpan(
      text: config.yFormatter(maxValue),
      style: config.legendStyle,
    );
    final verticalLegendPainter = TextPainter(
      text: maxValueLegend,
      textDirection: TextDirection.ltr,
    );
    verticalLegendPainter.layout();
    final maxValueLegendSize = verticalLegendPainter.size;
    verticalLegendPainter.paint(
      canvas,
      Offset(size.width - maxValueLegendSize.width, .0),
    );

    final thirdValue = maxValue / 3;
    final secondLineY =
        thirdValue.remap(.0, maxValue.toDouble(), .0, size.height);
    final thirdLineY =
        (thirdValue * 2.0).remap(.0, maxValue.toDouble(), .0, size.height);

    final secondValueLegend = TextSpan(
      text: config.yFormatter(maxValue - thirdValue),
      style: config.legendStyle,
    );
    verticalLegendPainter.text = secondValueLegend;
    verticalLegendPainter.layout();
    final secondValueLegendSize = verticalLegendPainter.size;
    verticalLegendPainter.paint(
      canvas,
      Offset(size.width - secondValueLegendSize.width, secondLineY),
    );

    final thirdValueLegend = TextSpan(
      text: config.yFormatter(thirdValue),
      style: config.legendStyle,
    );
    verticalLegendPainter.text = thirdValueLegend;
    verticalLegendPainter.layout();
    final thirdValueLegendSize = verticalLegendPainter.size;
    verticalLegendPainter.paint(
      canvas,
      Offset(size.width - thirdValueLegendSize.width, thirdLineY),
    );

    final vLegendWidth = [
          maxValueLegendSize.width,
          secondValueLegendSize.width,
          thirdValueLegendSize.width,
        ].fold(.0, (prev, curr) => max(prev, curr)) +
        6.0;

    // middle horizontal lines
    paint.strokeWidth = 1.0;
    paint.color = config.gridSecondaryColor;
    canvas.drawLine(
      Offset(.0, secondLineY),
      Offset(size.width, secondLineY),
      paint,
    );
    canvas.drawLine(
      Offset(.0, thirdLineY),
      Offset(size.width, thirdLineY),
      paint,
    );

    // marks
    paint.strokeWidth = 0;
    final sectionWidth = (size.width - vLegendWidth) / max(1, data.length);
    final barWidth = max(6.0, sectionWidth - config.padding);
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
          ..lineTo(left + barWidth - config.radius, .0) // top right
          ..arcToPoint(
            Offset(left + barWidth, config.radius),
            radius: Radius.circular(config.radius),
          ) // top right radius
          ..lineTo(left + barWidth, totalDisplayedHeight) // bottom right
          ..lineTo(left, totalDisplayedHeight) // bottom left
          ..close();
        // invert by vertical and offset to the right
        clipPath = clipPath.shift(
          Offset(config.padding * 0.5, barMaxHeight - totalDisplayedHeight),
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
          Rect rect = Rect.fromLTWH(left, .0, barWidth, displayedHeight);
          // invert by vertical and offset to the right
          rect = rect.shift(
            Offset(
              config.padding * 0.5,
              barMaxHeight - offset - displayedHeight,
            ),
          );
          canvas.drawRect(rect, paint);
          offset += displayedHeight;
        }

        canvas.restore();
      }

      legendPainter.dispose();
    }
    final bottomValueLegend = TextSpan(
      text: config.yFormatter(0),
      style: config.legendStyle,
    );
    verticalLegendPainter.text = bottomValueLegend;
    verticalLegendPainter.layout();
    final bottomValueLegendSize = verticalLegendPainter.size;
    verticalLegendPainter.paint(
      canvas,
      Offset(
        size.width - bottomValueLegendSize.width,
        barMaxHeight - bottomValueLegendSize.height,
      ),
    );
    verticalLegendPainter.dispose();

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
