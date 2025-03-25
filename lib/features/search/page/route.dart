part of "./view_model.dart";

final class _Route extends ModalRoute {
  final CapturedThemes capturedThemes;
  final Widget child;

  _Route({required this.capturedThemes, required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = Theme.of(context);
    const curve = Curves.decelerate;

    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: curve.transform(animation.value),
          child: ColoredBox(color: theme.colorScheme.scrim),
        ),

        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)).animate(animation),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 260);
}
