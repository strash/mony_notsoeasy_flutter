import "dart:math";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/separated/component.dart";
import "package:mony_app/features/stats/page/view_model.dart";

class StatsCategoriesComponent extends StatelessWidget {
  final double padding;

  const StatsCategoriesComponent({
    super.key,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    final viewModel = context.viewModel<StatsViewModel>();
    final categories = viewModel.categories;
    final totalCount = categories.fold(.0, (prev, curr) => prev + curr.$1);
    final chartData = categories.map((e) {
      return (
        e.$1,
        ex != null ? ex.from(e.$2.colorName).color : theme.colorScheme.tertiary,
      );
    });

    final account = viewModel.accountController.value;
    final formatter = NumberFormat.decimalPatternDigits(decimalDigits: 2);

    return AnimatedSwitcher(
      duration: Durations.short3,
      child: SeparatedComponent.list(
        key: Key("${totalCount}_$categories"),
        mainAxisSize: MainAxisSize.min,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10.0);
        },
        children: [
          // -> chart
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: SizedBox.fromSize(
              size: const Size.fromHeight(20.0),
              child: CustomPaint(
                size: Size.infinite,
                painter: _Painter(
                  minWidth: 4.0,
                  padding: 2.5,
                  radius: 4.0,
                  totalCount: totalCount,
                  data: chartData,
                ),
              ),
            ),
          ),

          // -> legend
          Row(
            children: [
              Expanded(
                // TODO: gradient
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  scrollDirection: Axis.horizontal,
                  child: SeparatedComponent.builder(
                    direction: Axis.horizontal,
                    mainAxisSize: MainAxisSize.min,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 25.0);
                    },
                    itemBuilder: (context, index) {
                      final item = categories.elementAt(index);
                      final value = account != null
                          ? item.$1.currency(
                              name: account.currency.name,
                              symbol: account.currency.symbol,
                              showDecimal: viewModel.isCentsVisible,
                            )
                          : formatter.format(item.$1);
                      final color = chartData.elementAt(index).$2;
                      final percent = formatter
                          .format(item.$1 * 100 / max(1.0, totalCount));

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // -> color marker
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 1.5, right: 5.0),
                            child: SizedBox.square(
                              dimension: 12.0,
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  color: color,
                                  shape: const SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(
                                        cornerRadius: 3.0,
                                        cornerSmoothing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // -> info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // -> title
                              Text(
                                item.$2.title,
                                style: GoogleFonts.golosText(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 3.0),

                              // -> amount
                              Text(
                                "$value\n$percent%",
                                style: GoogleFonts.golosText(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
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
