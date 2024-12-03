import "package:flutter/material.dart";
import "package:mony_app/app.dart";

final class _Route extends ModalRoute {
  final CapturedThemes capturedThemes;
  final WidgetBuilder builder;

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
    return capturedThemes.wrap(builder(context));
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  // TODO: возвращать вариант с разными моделями, чтобы в зависимости от модели
  // при закрытии этого экрана открывать экран модели (транзакция, тэг,
  // категория, счет) - Future<SearchVariant?>
  static Future<void> show(BuildContext context) async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    return navigator.push<void>(
      _Route(
        builder: (context) {
          return const SearchView();
        },
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Text("Search"),
        ],
      ),
    );
  }
}
