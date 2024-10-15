import "package:flutter/widgets.dart";

class SeparatedComponent extends StatelessWidget {
  final Axis direction;
  final int itemCount;
  final WidgetBuilder separatorBuilder;
  final IndexedWidgetBuilder itemBuilder;

  const SeparatedComponent({
    super.key,
    required this.direction,
    required this.itemCount,
    required this.separatorBuilder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final lenght = itemCount * 2 - 1;
    int count = 0;

    switch (direction) {
      case Axis.horizontal:
        return Row(
          children: List.generate(lenght, (index) {
            if (index.isOdd) return separatorBuilder(context);
            return itemBuilder(context, count++);
          }),
        );
      case Axis.vertical:
        return Column(
          children: List.generate(lenght, (index) {
            if (index.isOdd) return separatorBuilder(context);
            return itemBuilder(context, count++);
          }),
        );
    }
  }
}
