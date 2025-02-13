import "dart:math";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/components/components.dart";

part "./color_picker_controller.dart";
part "./color_picker_cursor_clipper.dart";
part "./color_picker_grid.dart";
part "./color_picker_palette.dart";
part "./color_picker_provider.dart";
part "./color_picker_item.dart";

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
      builder: (context, bottom) {
        return _ColorPickerValueProvider(
          controller: widget.controller,
          child: _ColorGrid(bottom),
        );
      },
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
        dimension: 48.0,
        child: TweenAnimationBuilder<Color?>(
          duration: Durations.short2,
          tween: ColorTween(
            begin: secondary.withValues(alpha: 0.0),
            end: secondary.withValues(alpha: _isActive ? 1.0 : 0.0),
          ),
          builder: (context, color, child) {
            // -> background
            return DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.surfaceContainer,
                shape: SmoothRectangleBorder(
                  side: BorderSide(color: color!),
                  borderRadius: const SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 15.0, cornerSmoothing: 0.6),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListenableBuilder(
                  listenable: widget.controller,
                  builder: (context, child) {
                    final color = widget.controller.value;
                    // -> color
                    return DecoratedBox(
                      decoration: ShapeDecoration(
                        color: color ?? const Color(0x00FFFFFF),
                        shape: SmoothRectangleBorder(
                          side: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          borderRadius: const SmoothBorderRadius.all(
                            SmoothRadius(
                              cornerRadius: 10.0,
                              cornerSmoothing: 0.6,
                            ),
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
