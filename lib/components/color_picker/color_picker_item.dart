part of "./color_picker.dart";

class _ColorGridItem extends StatefulWidget {
  final Color color;
  final RenderBox? Function() getAncestorBox;
  final void Function(Rect rect) onSelected;

  const _ColorGridItem({
    required this.color,
    required this.getAncestorBox,
    required this.onSelected,
  });

  @override
  State<_ColorGridItem> createState() => _ColorGridItemState();
}

class _ColorGridItemState extends State<_ColorGridItem> {
  ColorPickerController get _controller {
    return _ColorPickerValueProvider.of(context);
  }

  void _onTap() {
    final rb = context.findRenderObject() as RenderBox?;
    final parentRb = widget.getAncestorBox();
    if (rb == null || !rb.hasSize || parentRb == null || !parentRb.hasSize) {
      return;
    }
    const offset = Offset.zero;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        rb.localToGlobal(offset, ancestor: parentRb),
        rb.localToGlobal(
          rb.size.bottomRight(Offset.zero) + offset,
          ancestor: parentRb,
        ),
      ),
      Offset.zero & parentRb.size,
    );
    _controller.value = widget.color;
    widget.onSelected(position.toRect(parentRb.paintBounds));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      if (_controller.value == widget.color) _onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: SizedBox.expand(child: ColoredBox(color: widget.color)),
    );
  }
}
