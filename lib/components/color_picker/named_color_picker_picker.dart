part of "component.dart";

class ColorPickerComponent extends StatelessWidget {
  final ColorPickerController controller;

  const ColorPickerComponent({super.key, required this.controller});

  void _onTap(BuildContext context) {
    BottomSheetComponent.show<EColorName?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return _ColorPickerValueProvider(
          notifier: controller,
          child: _ColorGrid(bottom: bottom),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ex = theme.extension<ColorExtension>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.square(
        dimension: 48.0,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final colorName = controller.value;
            final endColor =
                ex?.from(colorName ?? EColorName.defaultValue).color ??
                theme.colorScheme.surfaceContainer;

            // -> color
            return TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: theme.colorScheme.surfaceContainer,
                end: endColor,
              ),
              duration: Durations.medium2,
              curve: Curves.easeInOut,
              builder: (context, color, child) {
                return DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: SmoothRectangleBorder(
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.1,
                        ),
                      ),
                      borderRadius: const SmoothBorderRadius.all(
                        SmoothRadius(cornerRadius: 16.0, cornerSmoothing: 0.6),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
