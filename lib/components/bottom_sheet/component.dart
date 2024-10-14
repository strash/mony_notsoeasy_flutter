import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app.dart";

class BottomSheetComponent extends StatelessWidget {
  final Widget child;

  const BottomSheetComponent({
    super.key,
    required this.child,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
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
              BottomSheetComponent(child: child),
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

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.lerp(
          theme.colorScheme.surfaceContainer,
          theme.colorScheme.surface,
          0.7,
        ),
        borderRadius: SmoothBorderRadius.all(
          SmoothRadius(
            cornerRadius: 26.r,
            cornerSmoothing: 1.0,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -> handle
          const _BottomSheetHandleComponent(),

          // -> content
          Flexible(child: child),
        ],
      ),
    );
  }
}

class _BottomSheetHandleComponent extends StatelessWidget {
  const _BottomSheetHandleComponent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: SizedBox.fromSize(
        size: Size.fromHeight(24.h),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 46.w,
            height: 4.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                borderRadius: SmoothBorderRadius.all(
                  SmoothRadius(cornerRadius: 2.r, cornerSmoothing: 1.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
