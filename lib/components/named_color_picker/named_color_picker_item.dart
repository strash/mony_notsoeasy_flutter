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
      padding: const EdgeInsets.all(3.0),
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
                borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                border: Border.all(
                  width: isActive ? 2.0 : .0,
                  color: color ?? theme.colorScheme.tertiary,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100.0)),
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
