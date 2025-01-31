import "dart:math";

import "package:flutter/material.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/category.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsCategoriesComponent extends StatelessWidget {
  const StatsCategoriesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<StatsViewModel>();
    final categories = viewModel.categories;
    final totalCount = categories.fold(.0, (prev, curr) => prev + curr.$1);

    return SizedBox.fromSize(
      size: const Size.fromHeight(20.0),
      child: AnimatedSwitcher(
        duration: Durations.short3,
        child: CustomPaint(
          key: Key("${totalCount}_$categories"),
          size: Size.infinite,
          painter: _Painter(
            totalCount: totalCount,
            minWidth: 4.0,
            padding: 2.5,
            radius: 4.0,
            data: categories,
            color: (name) {
              return ex != null && name != null
                  ? ex.from(name).color
                  : theme.colorScheme.tertiary;
            },
          ),
        ),
      ),
    );
  }
}

final class _Painter extends CustomPainter {
  final double totalCount;
  final double minWidth;
  final double padding;
  final double radius;
  final List<(double, CategoryModel)> data;
  final Color Function(EColorName? colorName) color;

  _Painter({
    required this.totalCount,
    required this.minWidth,
    required this.padding,
    required this.radius,
    required this.data,
    required this.color,
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
      paint.color = color(element.$2.colorName);
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
