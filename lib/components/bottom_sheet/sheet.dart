import "dart:math";

import "package:figma_squircle/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:mony_app/app.dart";
import "package:mony_app/components/bottom_sheet/handle.dart";

typedef TBottomSheetBuilder = Widget Function(
  BuildContext context,
  double bottom,
);

class BottomSheetComponent extends StatefulWidget {
  final bool showDragHandle;
  final TBottomSheetBuilder builder;

  const BottomSheetComponent({
    super.key,
    required this.showDragHandle,
    required this.builder,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    bool showDragHandle = true,
    required TBottomSheetBuilder builder,
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
  State<BottomSheetComponent> createState() => _BottomSheetComponentState();
}

class _BottomSheetComponentState extends State<BottomSheetComponent>
    with WidgetsBindingObserver {
  final keyboardNotifier = ValueNotifier<double>(.0);

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    keyboardNotifier.value = MediaQuery.of(context).viewInsets.bottom;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    keyboardNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = SmoothRadius(cornerRadius: 26.r, cornerSmoothing: 1.0);

    return ValueListenableBuilder<double>(
      valueListenable: keyboardNotifier,
      builder: (context, bottom, child) {
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
              if (widget.showDragHandle)
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: const BottomSheetHandleComponent(),
                ),

              // -> content
              Flexible(
                child: widget.builder(
                  context,
                  max(bottom, MediaQuery.viewPaddingOf(context).bottom),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}