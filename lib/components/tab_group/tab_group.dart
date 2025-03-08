import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/descriptable/descriptable.dart";
import "package:mony_app/common/extensions/extensions.dart";

part "./tab_group_controller.dart";
part "./tab_group_item.dart";

class TabGroupComponent<T extends IDescriptable> extends StatefulWidget {
  final List<T> values;
  final TabGroupController<T> controller;
  final void Function(T value)? onSelected;

  const TabGroupComponent({
    super.key,
    required this.values,
    required this.controller,
    this.onSelected,
  });

  @override
  State<TabGroupComponent> createState() => _TabGroupComponentState<T>();
}

class _TabGroupComponentState<T extends IDescriptable>
    extends State<TabGroupComponent<T>> {
  final _rectNotifier = ValueNotifier<RelativeRect?>(null);

  final _padding = const EdgeInsets.all(3.0);

  RenderBox? _getBox() => context.findRenderObject() as RenderBox?;

  Size _getSize(T value) {
    const padding = TabGroupEntryComponent.padding;
    final style = TabGroupEntryComponent.style(context);
    final span = TextSpan(text: value.description, style: style);
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    final size = painter.size;
    painter.dispose();
    return size.add(Size(padding.horizontal, padding.vertical));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final box = _getBox();
      if (box == null) return;
      final size = _getSize(widget.controller.value);
      _rectNotifier.value = RelativeRect.fromSize(
        Rect.fromLTWH(_padding.left, _padding.top, size.width, size.height),
        box.size,
      );
    });
  }

  @override
  void dispose() {
    _rectNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight =
        MediaQuery.platformBrightnessOf(context) == Brightness.light;

    return ClipSmoothRect(
      radius: const SmoothBorderRadius.all(
        SmoothRadius(cornerRadius: 14.0, cornerSmoothing: 0.6),
      ),
      child: Stack(
        children: [
          // -> bg
          ColoredBox(
            color:
                isLight
                    ? theme.colorScheme.surfaceContainer
                    : theme.colorScheme.surfaceContainerLowest,
            child: Padding(
              padding: _padding,
              child: SizedBox.fromSize(
                size: widget.values
                    .map<Size>((value) => _getSize(value))
                    .fold<Size>(Size.zero, (prev, curr) => curr.addWidth(prev)),
              ),
            ),
          ),

          // -> active bg
          ListenableBuilder(
            listenable: _rectNotifier,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color:
                    isLight
                        ? theme.colorScheme.surface
                        : theme.colorScheme.surfaceContainerHighest,
                shadows: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: .15),
                    blurRadius: 6.0,
                    spreadRadius: -1.0,
                    offset: const Offset(.0, 2.0),
                  ),
                ],
                shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 11.0, cornerSmoothing: 0.6),
                  ),
                ),
              ),
            ),
            builder: (context, child) {
              final rect = _rectNotifier.value;
              if (rect == null) return const SizedBox();

              return AnimatedPositioned(
                duration: Durations.short4,
                curve: Curves.easeInOut,
                top: rect.top,
                bottom: rect.bottom,
                left: rect.left,
                right: rect.right,
                child: child!,
              );
            },
          ),

          // -> items
          Padding(
            padding: _padding,
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.values
                      .map((value) {
                        final isActive = value == widget.controller.value;

                        return TabGroupEntryComponent<T>(
                          key: Key("${value.name}_$isActive"),
                          value: value,
                          isActive: isActive,
                          rectNotifier: _rectNotifier,
                          parent: _getBox,
                          onTap: (T newValue) {
                            widget.controller.value = newValue;
                            if (widget.onSelected != null) {
                              widget.onSelected!.call(newValue);
                            }
                          },
                        );
                      })
                      .toList(growable: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
