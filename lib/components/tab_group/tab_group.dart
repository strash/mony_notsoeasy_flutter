import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
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

  final _padding = EdgeInsets.all(3.r);

  RenderBox? _getBox() => context.findRenderObject() as RenderBox?;

  Size _getSize(T value) {
    final padding = TabGroupEntryComponent.padding;
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

    return ClipSmoothRect(
      radius: SmoothBorderRadius.all(
        SmoothRadius(cornerRadius: 14.r, cornerSmoothing: 1.0),
      ),
      child: Stack(
        children: [
          // -> bg
          ColoredBox(
            color: theme.colorScheme.surfaceContainer,
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
          ValueListenableBuilder<RelativeRect?>(
            valueListenable: _rectNotifier,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: theme.colorScheme.surface,
                shadows: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(.15),
                    blurRadius: 6.0,
                    spreadRadius: -1.0,
                    offset: const Offset(.0, 2.0),
                  ),
                ],
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(
                    SmoothRadius(cornerRadius: 11.r, cornerSmoothing: 1.0),
                  ),
                ),
              ),
            ),
            builder: (context, rect, child) {
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
                  children: widget.values.map((value) {
                    return TabGroupEntryComponent<T>(
                      value: value,
                      isActive: value == widget.controller.value,
                      rectNotifier: _rectNotifier,
                      parent: _getBox,
                      onTap: (T newValue) {
                        widget.controller.value = newValue;
                        if (widget.onSelected != null) {
                          widget.onSelected!.call(newValue);
                        }
                      },
                    );
                  }).toList(growable: false),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
