part of "./view_model.dart";

final class _Route extends ModalRoute {
  final CapturedThemes capturedThemes;
  final Widget child;

  _Route({
    required this.capturedThemes,
    required this.child,
  });

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        return capturedThemes.wrap(
          Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
