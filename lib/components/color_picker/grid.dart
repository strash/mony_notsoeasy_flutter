part of "./component.dart";

class _ColorGrid extends StatefulWidget {
  const _ColorGrid();

  @override
  State<_ColorGrid> createState() => _ColorGridState();
}

class _ColorGridState extends State<_ColorGrid> {
  Rect? _rect;
  late final _padding = EdgeInsets.fromLTRB(
    10.r,
    0.0,
    10.r,
    MediaQuery.viewPaddingOf(context).bottom + 20.h,
  );
  final double _cursorThickness = 5.r;
  final _cursorInnerRadius = 9.r;

  RenderBox? _getRenderBox() {
    return context.findRenderObject() as RenderBox?;
  }

  void _onSelected(Rect rect) {
    setState(() {
      _rect = rect
          .shift(-Offset(_padding.left, _padding.top))
          .inflate(_cursorThickness);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Palette().grid12x10;
    final theme = Theme.of(context);
    final viewSize = MediaQuery.sizeOf(context);
    final itemWidth = (viewSize.width - _padding.horizontal) / 12;
    final borderRadius = SmoothBorderRadius.all(
      SmoothRadius(
        cornerRadius: _cursorInnerRadius,
        cornerSmoothing: 1.0,
      ),
    );
    final cursorBorderRadius = SmoothBorderRadius.all(
      SmoothRadius(
        cornerRadius: _cursorInnerRadius + _cursorThickness,
        cornerSmoothing: 1.0,
      ),
    );
    final itemSize = Size(itemWidth * 12, itemWidth * 10);
    final shadow = MediaQuery.platformBrightnessOf(context) == Brightness.light
        ? theme.colorScheme.shadow
        : theme.colorScheme.shadow.withOpacity(0.3);

    return Padding(
      padding: _padding,
      child: SizedBox.fromSize(
        size: itemSize,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            // -> color grid
            ClipRRect(
              borderRadius: borderRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: palette.map((row) {
                  return Expanded(
                    child: Row(
                      children: row.map((color) {
                        return Expanded(
                          child: _ColorGridItem(
                            color: color,
                            getAncestorBox: _getRenderBox,
                            onSelected: _onSelected,
                          ),
                        );
                      }).toList(growable: false),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),

            // -> border
            IgnorePointer(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderRadius: borderRadius,
                    side: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                      strokeAlign: CircularProgressIndicator.strokeAlignOutside,
                    ),
                  ),
                ),
              ),
            ),

            // -> cursor
            if (_rect != null)
              Positioned.fromRect(
                rect: _rect!,
                child: IgnorePointer(
                  child: SizedBox.fromSize(
                    size: Size.square(itemWidth),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // -> shadow
                        DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: SmoothRectangleBorder(
                              borderRadius: cursorBorderRadius,
                            ),
                            shadows: [
                              BoxShadow(
                                color: shadow,
                                blurRadius: 10.0,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                          ),
                        ),

                        // -> border
                        ClipPath(
                          clipper: _CursorClipper(
                            radius: _cursorInnerRadius,
                            padding: EdgeInsets.all(_cursorThickness),
                          ),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              shape: SmoothRectangleBorder(
                                borderRadius: cursorBorderRadius,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
