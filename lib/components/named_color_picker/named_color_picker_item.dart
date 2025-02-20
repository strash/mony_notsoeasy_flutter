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
    final namedColor =
        ex?.from(colorName).color ?? theme.colorScheme.surfaceContainer;
    const borderRadius = BorderRadius.all(Radius.circular(100.0));
    const transparent = Color(0x00FFFFFF);

    final controller = _controller(context);
    final isActive = controller.value == colorName;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(context),
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: transparent,
            end: isActive ? theme.colorScheme.tertiaryContainer : transparent,
          ),
          duration: Durations.medium2,
          curve: Curves.easeInOut,
          builder: (context, color, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // -> color
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      width: isActive ? 2.0 : .0,
                      color: color ?? theme.colorScheme.tertiary,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: namedColor,
                      ),
                    ),
                  ),
                ),

                // -> icon
                Center(
                  child: AnimatedOpacity(
                    opacity: isActive ? 1.0 : .0,
                    duration: Durations.short3,
                    child: SvgPicture.asset(
                      Assets.icons.checkmarkBold,
                      width: 26.0,
                      height: 26.0,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.surface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
