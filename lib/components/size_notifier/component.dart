import "package:flutter/widgets.dart";

class SizeNotifierComponent extends StatelessWidget {
  final SizeNotifierController controller;
  final double? width;
  final double? height;
  final Widget child;

  const SizeNotifierComponent({
    required this.controller,
    this.width,
    this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final a = context.findRenderObject() as RenderBox?;
      if (a != null && !controller.isDisposed) {
        controller.size = a.size;
      }
    });

    return SizedBox(width: width, height: height, child: child);
  }
}

// NOTE: don't use ValueNotifier because it doesn't notify if values are the
// same
final class SizeNotifierController extends ChangeNotifier {
  Size _size = Size.zero;
  bool isDisposed = false;

  Size get size {
    return _size;
  }

  set size(Size value) {
    _size = value;
    notifyListeners();
  }
}
