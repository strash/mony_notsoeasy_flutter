import "dart:math";

import "package:flutter/widgets.dart";

class SeparatedComponent extends StatelessWidget {
  final Axis direction;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final int itemCount;
  final WidgetBuilder separatorBuilder;
  final IndexedWidgetBuilder itemBuilder;

  const SeparatedComponent({
    super.key,
    this.direction = Axis.vertical,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.itemCount,
    required this.separatorBuilder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final lenght = max(0, itemCount * 2 - 1);
    int count = 0;
    final children = List.generate(lenght, (index) {
      if (index.isOdd) return separatorBuilder(context);
      return itemBuilder(context, count++);
    }).toList(growable: false);

    return switch (direction) {
      Axis.horizontal => Row(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      Axis.vertical => Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
    };
  }
}
