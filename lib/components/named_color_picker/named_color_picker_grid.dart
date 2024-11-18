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
        const AppBarComponent(
          title: Text("Цвет"),
          useSliver: false,
          showDragHandle: true,
        ),

        // -> colors
        GridView.count(
          padding: EdgeInsets.fromLTRB(15.r, 20.h, 15.r, bottom + 20.h),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 6,
          children: EColorName.values.map((e) {
            return ListenableBuilder(
              listenable: _NamedColorPickerValueProvider.of(context),
              builder: (context, child) {
                return _ColorGridItem(colorName: e);
              },
            );
          }).toList(growable: false),
        ),
      ],
    );
  }
}
