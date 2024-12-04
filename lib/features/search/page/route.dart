part of "./page.dart";

final class _Route extends ModalRoute {
  final CapturedThemes capturedThemes;
  final Widget Function(BuildContext context, Animation<double> anim) builder;

  _Route({
    required this.capturedThemes,
    required this.builder,
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
      builder: (context, child) {
        return capturedThemes.wrap(
          builder(context, animation),
        );
      },
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 360);
}
