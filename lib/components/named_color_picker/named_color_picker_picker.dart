part of "component.dart";

class NamedColorPickerComponent extends StatelessWidget {
  final NamedColorPickerController controller;

  const NamedColorPickerComponent({
    super.key,
    required this.controller,
  });

  void _onTap(BuildContext context) {
    BottomSheetComponent.show<EColorName?>(
      context,
      builder: (context, bottom) {
        return _NamedColorPickerValueProvider(
          controller: controller,
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
        dimension: 48.r,
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final colorName = controller.value;
            // -> color
            return TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                begin: theme.colorScheme.surfaceContainer,
                end: ex?.from(colorName ?? EColorName.defaultValue).color ??
                    theme.colorScheme.surfaceContainer,
              ),
              duration: Durations.medium2,
              curve: Curves.easeInOut,
              builder: (context, color, child) {
                return DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: SmoothRectangleBorder(
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                      ),
                      borderRadius: SmoothBorderRadius.all(
                        SmoothRadius(
                          cornerRadius: 15.r,
                          cornerSmoothing: 1.0,
                        ),
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