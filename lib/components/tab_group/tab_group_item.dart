part of "./tab_group.dart";

class TabGroupEntryComponent<T extends IDescriptable> extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final box = context.findRenderObject() as RenderBox?;
        final parentBox = parent();
        if (box != null &&
            box.hasSize &&
            parentBox != null &&
            parentBox.hasSize) {
          final rect = _getRect(box);
          final parentRect = _getRect(parentBox);
          rectNotifier.value = RelativeRect.fromRect(rect, parentRect);
        }
        onTap(value);
      },
      child: Padding(
        padding: padding,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short4,
          tween: ColorTween(
            begin: theme.colorScheme.onSurfaceVariant,
            end: isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
          builder: (context, color, child) {
            return Text(
              value.description,
              style: style(context).copyWith(color: color),
            );
          },
        ),
      ),
    );
  }
}
