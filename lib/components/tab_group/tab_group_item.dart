part of "./tab_group.dart";

class TabGroupEntryComponent<T extends IDescriptable> extends StatefulWidget {
  final T value;
  final bool isActive;
  final ValueNotifier<RelativeRect?> rectNotifier;
  final RenderBox? Function() parent;
  final void Function(T newValue) onTap;

  static final EdgeInsets padding = EdgeInsets.symmetric(
    horizontal: 14.w,
    vertical: 4.h,
  );

  static TextStyle style(BuildContext context) {
    return GoogleFonts.golosText(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    );
  }

  const TabGroupEntryComponent({
    super.key,
    required this.value,
    required this.isActive,
    required this.rectNotifier,
    required this.parent,
    required this.onTap,
  });

  @override
  State<TabGroupEntryComponent<T>> createState() =>
      _TabGroupEntryComponentState<T>();
}

class _TabGroupEntryComponentState<T extends IDescriptable>
    extends State<TabGroupEntryComponent<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      _notifyRect();
    });
  }

  Rect _getRect(RenderBox box) {
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;
    return Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );
  }

  void _notifyRect() {
    final box = context.findRenderObject() as RenderBox?;
    final parentBox = widget.parent();
    if (box != null && box.hasSize && parentBox != null && parentBox.hasSize) {
      final rect = _getRect(box);
      final parentRect = _getRect(parentBox);
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
            end: widget.isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
          builder: (context, color, child) {
            return Text(
              widget.value.description,
              style:
                  TabGroupEntryComponent.style(context).copyWith(color: color),
            );
          },
        ),
      ),
    );
  }
}
