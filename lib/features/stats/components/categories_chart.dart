import "dart:math";

import "package:flutter/material.dart";
import "package:mony_app/common/extensions/extensions.dart";

class StatsCategoriesChartComponent extends StatelessWidget {
  final double padding;
  final double totalCount;
  final Iterable<(double, Color)> data;

  const StatsCategoriesChartComponent({
    super.key,
    required this.padding,
    required this.totalCount,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: SizedBox.fromSize(
        size: const Size.fromHeight(8.0),
        child: CustomPaint(
          size: Size.infinite,
          painter: _Painter(
            minWidth: 4.0,
            padding: 3.0,
            radius: 3.0,
            totalCount: totalCount,
            data: data,
          ),
        ),
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final double minWidth;
  final double padding;
  final double radius;
  final double totalCount;
  final Iterable<(double, Color)> data;

  _Painter({
    required this.minWidth,
    required this.padding,
    required this.radius,
    required this.totalCount,
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint();

    final paddingCount = max(0, data.length - 1);
    final maxPaddingWidth = padding * paddingCount;
    final maxWidth = size.width - maxPaddingWidth;
    double tempWidth = maxWidth;

    final List<double> widths = [];
    {
      int index = max(0, data.length - 1);
      while (index >= 0) {
        final element = data.elementAt(index);
        final width = element.$1.remap(.0, totalCount, .0, tempWidth);
        final m = max(minWidth, width);
        widths.add(m);
        if (m != width) tempWidth -= m - width;
        index--;
      }
      widths.sort((a, b) => b.compareTo(a));
    }

    double offset = .0;
    for (final (index, element) in data.indexed) {
      paint.color = element.$2;
      final width = widths.elementAt(index);
      final rect = Rect.fromLTWH(.0 + offset, .0, width, size.height);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rrect, paint);
      offset += width + padding;
    }
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return totalCount != oldDelegate.totalCount || data != oldDelegate.data;
  }
}
