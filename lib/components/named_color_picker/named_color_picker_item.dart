part of "component.dart";

class _ColorGridItem extends StatelessWidget {
  final EColorName colorName;

  const _ColorGridItem({required this.colorName});

  NamedColorPickerController _controller(BuildContext context) {
    return _NamedColorPickerValueProvider.of(context);
  }

  void _onTap(BuildContext context) {
    _controller(context).value = colorName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();
    final controller = _controller(context);
    final isActive = controller.value == colorName;

    return Padding(
      padding: EdgeInsets.all(3.r),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(context),
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: const Color(0x00FFFFFF),
            end:
                isActive ? theme.colorScheme.tertiary : const Color(0x00FFFFFF),
          ),
          duration: Durations.medium2,
          curve: Curves.easeInOut,
          builder: (context, color, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
                border: Border.all(
                  width: isActive ? 2.0 : .0,
                  color: color ?? theme.colorScheme.tertiary,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.r)),
                    color: ex?.from(colorName).color ??
                        theme.colorScheme.surfaceContainer,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
