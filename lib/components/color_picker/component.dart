import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/components/components.dart";

part "./controller.dart";
part "./cursor_clipper.dart";
part "./grid.dart";
part "./palette.dart";
part "./provider.dart";
part "./item.dart";

class ColorPickerComponent extends StatefulWidget {
  final ColorPickerController controller;

  const ColorPickerComponent({super.key, required this.controller});

  @override
  State<ColorPickerComponent> createState() => _ColorPickerComponentState();
}

class _ColorPickerComponentState extends State<ColorPickerComponent> {
  bool _isActive = false;

  Future<void> _onTap(BuildContext context) async {
    setState(() => _isActive = true);
    final value = await BottomSheetComponent.show<Color?>(
      context,
      child: _ValueProvider(
        controller: widget.controller,
        child: const _ColorGrid(),
      ),
    );
    if (value != null) widget.controller.value = value;
    setState(() => _isActive = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: SizedBox.square(
        dimension: 48.r,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short2,
          tween: ColorTween(
            begin: secondary.withOpacity(0.0),
            end: secondary.withOpacity(_isActive ? 1.0 : 0.0),
          ),
          builder: (context, color, child) {
            // -> background
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                border: Border.all(color: color!),
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(
                    cornerRadius: 15.r,
                    cornerSmoothing: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, child) {
                    final color = widget.controller.value;
                    // -> color
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: color ?? const Color(0x00FFFFFF),
                        border: Border.all(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                        ),
                        borderRadius: SmoothBorderRadius.all(
                          SmoothRadius(
                            cornerRadius: 10.r,
                            cornerSmoothing: 1.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}