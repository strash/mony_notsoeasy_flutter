import "dart:math";

import "package:flutter/widgets.dart";

enum _Type { builder, list }

class SeparatedComponent extends StatelessWidget {
  final Axis direction;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final IndexedWidgetBuilder separatorBuilder;
  final int? itemCount;
  final IndexedWidgetBuilder? itemBuilder;
  final Iterable<Widget>? children;

  final _Type _type;

  const SeparatedComponent.builder({
    super.key,
    this.direction = Axis.vertical,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required int itemCount,
    required this.separatorBuilder,
    required IndexedWidgetBuilder itemBuilder,
  }) : _type = _Type.builder,
       // ignore: prefer_initializing_formals
       itemCount = itemCount,
       // ignore: prefer_initializing_formals
       itemBuilder = itemBuilder,
       children = null;

  const SeparatedComponent.list({
    super.key,
    this.direction = Axis.vertical,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.separatorBuilder,
    required Iterable<Widget> children,
  }) : _type = _Type.list,
       // ignore: prefer_initializing_formals
       children = children,
       itemCount = null,
       itemBuilder = null;

  @override
  Widget build(BuildContext context) {
    final List<Widget> list;
    int count = 0;
    int separatorCount = 0;

    switch (_type) {
      case _Type.builder:
        final lenght = max(0, itemCount! * 2 - 1);
        list = List.generate(lenght, (index) {
          if (index.isOdd) return separatorBuilder(context, separatorCount++);
          return itemBuilder!(context, count++);
        }).toList(growable: false);

      case _Type.list:
        final lenght = max(0, children!.length * 2 - 1);
        list = List.generate(lenght, (index) {
          if (index.isOdd) return separatorBuilder(context, separatorCount++);
          return children!.elementAt(count++);
        }).toList(growable: false);
    }

    return switch (direction) {
      Axis.horizontal => Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: list,
      ),
      Axis.vertical => Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: list,
      ),
    };
  }
}
