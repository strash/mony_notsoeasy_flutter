import "dart:math";

import "package:figma_squircle_updated/figma_squircle.dart";
import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/components/bottom_sheet/handle.dart";

typedef TBottomSheetBuilder =
    Widget Function(BuildContext context, double bottom);

class BottomSheetComponent extends StatefulWidget {
  final bool showDragHandle;
  final bool largeHandle;
  final TBottomSheetBuilder builder;

  const BottomSheetComponent({
    super.key,
    required this.showDragHandle,
    required this.largeHandle,
    required this.builder,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    bool showDragHandle = true,
    bool largeHandle = true,
    required TBottomSheetBuilder builder,
  }) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    final theme = Theme.of(context);

    return navigator.push<T?>(
      ModalBottomSheetRoute<T>(
        builder: (context) {
          return BottomSheetComponent(
            showDragHandle: showDragHandle,
            largeHandle: largeHandle,
            builder: builder,
          );
        },
        useSafeArea: true,
        isScrollControlled: true,
        modalBarrierColor: theme.colorScheme.scrim.withValues(alpha: 0.4),
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
  double _bottomOffset = .0;

  @override
  void didChangeMetrics() {
    if (mounted) {
      setState(() {
        _bottomOffset = max(
          MediaQuery.viewInsetsOf(context).bottom,
          MediaQuery.viewPaddingOf(context).bottom,
        );
      });
    }
    super.didChangeMetrics();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surface,
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 20.0, cornerSmoothing: 0.6),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -> handle
          if (widget.showDragHandle)
            Padding(
              padding: EdgeInsets.only(bottom: widget.largeHandle ? 20.0 : .0),
              child: const BottomSheetHandleComponent(),
            ),

          // -> content
          Flexible(child: widget.builder(context, _bottomOffset)),
        ],
      ),
    );
  }
}
