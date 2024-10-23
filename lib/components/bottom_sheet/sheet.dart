import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app.dart";
import "package:mony_app/components/bottom_sheet/handle.dart";

class BottomSheetComponent extends StatelessWidget {
  final bool showDragHandle;
  final WidgetBuilder builder;

  const BottomSheetComponent({
    super.key,
    required this.showDragHandle,
    required this.builder,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    bool showDragHandle = true,
    required WidgetBuilder builder,
  }) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    final theme = Theme.of(context);

    return navigator.push(
      ModalBottomSheetRoute<T>(
        builder: (context) {
          return BottomSheetComponent(
            showDragHandle: showDragHandle,
            builder: builder,
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

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: theme.colorScheme.surface,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(radius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -> handle
          if (showDragHandle) const BottomSheetHandleComponent(),

          // -> content
          Flexible(child: builder(context)),
        ],
      ),
    );
  }
}
