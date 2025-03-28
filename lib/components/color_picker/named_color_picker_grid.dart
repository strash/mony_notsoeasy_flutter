part of "component.dart";

class _ColorGrid extends StatelessWidget {
  final double bottom;

  const _ColorGrid({required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -> appbar
        AppBarComponent(
          title: Text(context.t.components.color_picker.title),
          useSliver: false,
          showBackground: false,
          showDragHandle: true,
        ),

        // -> colors
        GridView.count(
          padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, bottom + 40.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 6,
          children: EColorName.values
              .map((e) => _ColorGridItem(colorName: e))
              .toList(growable: false),
        ),
      ],
    );
  }
}
