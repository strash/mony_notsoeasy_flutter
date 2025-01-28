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

    final thirdValue = maxValue / 3;

    // max legend width
    final vMaxLegendWidth = config.padding +
        [maxValue, maxValue - thirdValue, thirdValue, .0].map((e) {
          return _measureLegend(
            text: config.yFormatter(e),
            style: config.legendStyle,
          );
        }).fold(.0, (prev, curr) => max(prev, curr.width));

    // marks
    paint.strokeWidth = 0;
    final sectionWidth = (size.width - vMaxLegendWidth) / max(1, data.length);
    final barWidth = max(6.0, sectionWidth - config.padding);
    double barMaxHeight = size.height;
    for (final (index, value) in data.indexed) {
      final left = index * sectionWidth;

      // legend
      final legendSize = _paintLegend(
        canvas: canvas,
        text: value["xLegend"]?.toString() ?? "",
        textAlign: TextAlign.center,
        style: config.legendStyle,
        minWidth: sectionWidth,
        offset: (textSize) => Offset(left, size.height - textSize.height),
      );

      final y = value["y"] as List<Map<String, dynamic>>?;
      if (y != null) {
        canvas.save();

        // mask for mark groups
        const minHeight = 5.0;
        barMaxHeight = size.height - legendSize.height - 3.0;
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
        // invert vertically and offset to the right
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
    }

    // top vertical legend
    _paintLegend(
      canvas: canvas,
      text: config.yFormatter(maxValue),
      style: config.legendStyle,
      offset: (textSize) => Offset(size.width - textSize.width, .0),
    );

    // first middle vertical legend
    final secondLineY =
        thirdValue.remap(.0, maxValue.toDouble(), .0, barMaxHeight);
    _paintLegend(
      canvas: canvas,
      text: config.yFormatter(maxValue - thirdValue),
      style: config.legendStyle,
      offset: (textSize) => Offset(size.width - textSize.width, secondLineY),
    );

    // second middle vertical legend
    final thirdLineY =
        (thirdValue * 2.0).remap(.0, maxValue.toDouble(), .0, barMaxHeight);
    _paintLegend(
      canvas: canvas,
      text: config.yFormatter(thirdValue),
      style: config.legendStyle,
      offset: (textSize) => Offset(size.width - textSize.width, thirdLineY),
    );

    // bottom vertical legend
    _paintLegend(
      canvas: canvas,
      text: config.yFormatter(0),
      style: config.legendStyle,
      offset: (textSize) {
        return Offset(
          size.width - textSize.width,
          barMaxHeight - textSize.height,
        );
      },
    );

    // grid
    paint.strokeWidth = 1.0;
    paint.color = config.gridColor;
    // top line
    canvas.drawLine(Offset.zero, Offset(size.width, .0), paint);
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
    // bottom line
    paint.color = config.gridColor;
    paint.colorFilter = null;
    canvas.drawLine(
      Offset(.0, barMaxHeight),
      Offset(size.width, barMaxHeight),
      paint,
    );

    // median
    if (config.showMedian &&
        config.medianLineColor != null &&
        config.medianStyle != null) {
      final values = data.map((value) {
        final y = value["y"] as List<Map<String, dynamic>>?;
        if (y == null) return 0;
        return y.fold(.0, (prev, curr) => prev + (curr["value"] as num? ?? .0));
      });
      final median =
          values.fold(.0, (prev, curr) => prev + curr) / max(1, values.length);
      final yPos = barMaxHeight -
          median.remap(.0, maxValue.toDouble(), .0, barMaxHeight);
      final medianPadding = config.medianPadding;

      // legend
      _paintLegend(
        canvas: canvas,
        text: config.yFormatter(median),
        style: config.medianStyle!,
        // NOTE: drawing a rect with a line here because why not
        offset: (textSize) {
          // line
          paint.color = config.medianLineColor!;
          canvas.drawLine(
            Offset(.0, yPos),
            Offset(
              size.width - textSize.width - medianPadding.horizontal,
              yPos,
            ),
            paint,
          );

          // rect
          final medianRect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width - textSize.width - medianPadding.horizontal,
              yPos - textSize.height * .5 - medianPadding.top,
              textSize.width + medianPadding.horizontal,
              textSize.height + medianPadding.vertical,
            ),
            Radius.circular(config.medianRadius),
          );
          canvas.drawRRect(medianRect, paint);

          return Offset(
            size.width - textSize.width - medianPadding.right,
            yPos - textSize.height * .5 - textSize.height * .04,
          );
        },
      );
    }
  }

  Size _measureLegend({
    required String text,
    required TextStyle style,
    double minWidth = .0,
    double maxWidth = double.infinity,
  }) {
    final legend = TextSpan(text: text, style: style);
    final painter = TextPainter(text: legend, textDirection: TextDirection.ltr);
    painter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final size = painter.size;
    painter.dispose();
    return size;
  }

  Size _paintLegend({
    required Canvas canvas,
    required String text,
    TextAlign textAlign = TextAlign.start,
    required TextStyle style,
    double minWidth = .0,
    double maxWidth = double.infinity,
    required Offset Function(Size size) offset,
  }) {
    final legend = TextSpan(text: text, style: style);
    final painter = TextPainter(
      text: legend,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );
    painter.layout(minWidth: minWidth, maxWidth: maxWidth);
    final size = painter.size;
    painter.paint(canvas, offset(size));
    painter.dispose();
    return size;
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return data != oldDelegate.data ||
        config != oldDelegate.config ||
        maxValue != oldDelegate.maxValue;
  }
}
