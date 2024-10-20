import "dart:math";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app.dart";
import "package:mony_app/components/bottom_sheet/handle.dart";

class BottomSheetComponent extends StatelessWidget {
  final double initialChildSize;
  final bool expand;
  final bool showDragHandle;
  final ScrollableWidgetBuilder builder;

  const BottomSheetComponent({
    super.key,
    required this.initialChildSize,
    required this.expand,
    required this.showDragHandle,
    required this.builder,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    double initialChildSize = 0.6,
    bool expand = true,
    bool showDragHandle = true,
    required ScrollableWidgetBuilder builder,
  }) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    final theme = Theme.of(context);

    return navigator.push(
      ModalBottomSheetRoute<T>(
        builder: (context) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BottomSheetComponent(
                initialChildSize: initialChildSize,
                expand: expand,
                showDragHandle: showDragHandle,
                builder: builder,
              ),
            ],
          );
        },
        useSafeArea: true,
        isScrollControlled: true,
        modalBarrierColor: theme.colorScheme.scrim.withOpacity(0.3),
        backgroundColor: Colors.transparent,
        showDragHandle: false,
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = SmoothRadius(cornerRadius: 26.r, cornerSmoothing: 1.0);
    final minSize = min(0.5, initialChildSize);

    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      snapSizes: expand ? [initialChildSize] : null,
      initialChildSize: initialChildSize,
      minChildSize: expand ? minSize : min(0.999, initialChildSize - 0.001),
      maxChildSize: expand ? 1.0 : initialChildSize,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: SmoothBorderRadius.all(radius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // -> handle
              if (showDragHandle) const BottomSheetHandleComponent(),

              // -> content
              Flexible(child: builder(context, scrollController)),
            ],
          ),
        );
      },
    );
  }
}
