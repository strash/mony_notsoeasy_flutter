part of "./tab_group.dart";

class TabGroupEntryComponent<T> extends StatefulWidget {
  final T value;
  final TTabGroupEntryDescription<T> description;
  final bool isActive;
  final ValueNotifier<RelativeRect?> rectNotifier;
  final RenderBox? Function() parent;
  final void Function(T newValue) onTap;

  static const EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 18.0,
    vertical: 5.0,
  );

  static TextStyle style(BuildContext context) {
    return GoogleFonts.golosText(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    );
  }

  const TabGroupEntryComponent({
    super.key,
    required this.value,
    required this.description,
    required this.isActive,
    required this.rectNotifier,
    required this.parent,
    required this.onTap,
  });

  @override
  State<TabGroupEntryComponent<T>> createState() =>
      _TabGroupEntryComponentState<T>();
}

class _TabGroupEntryComponentState<T> extends State<TabGroupEntryComponent<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (widget.isActive) _notifyRect();
    });
  }

  Rect _getRect(RenderBox box) {
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }

  void _notifyRect() {
    if (!context.mounted) return;
    final rb = context.findRenderObject() as RenderBox?;
    final parentRb = widget.parent();
    if (rb != null && rb.hasSize && parentRb != null && parentRb.hasSize) {
      final rect = _getRect(rb);
      final parentRect = _getRect(parentRb);
      widget.rectNotifier.value = RelativeRect.fromRect(rect, parentRect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _notifyRect();
        widget.onTap(widget.value);
      },
      child: Padding(
        padding: TabGroupEntryComponent.padding,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short4,
          tween: ColorTween(
            begin: theme.colorScheme.onSurfaceVariant,
            end:
                widget.isActive
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
          ),
          builder: (context, color, child) {
            return Text(
              widget.description(widget.value),
              style: TabGroupEntryComponent.style(
                context,
              ).copyWith(color: color),
            );
          },
        ),
      ),
    );
  }
}
