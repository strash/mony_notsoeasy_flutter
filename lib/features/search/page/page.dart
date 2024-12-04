import "package:flutter/material.dart";
import "package:mony_app/app.dart";
import "package:mony_app/features/search/page/view_model.dart";

export "./view_model.dart";

part "./route.dart";

class SearchPage extends StatelessWidget {
  final double distance;
  final Animation<double> animation;
  final AnimationStatusListener statusListener;

  const SearchPage({
    super.key,
    required this.distance,
    required this.animation,
    required this.statusListener,
  });

  // TODO: возвращать вариант с разными моделями, чтобы в зависимости от модели
  // при закрытии этого экрана открывать экран модели (транзакция, тэг,
  // категория, счет) - Future<SearchVariant?>
  static Future<void> show(
    BuildContext context, {
    required double distance,
    required AnimationStatusListener statusListener,
  }) async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return Future.value();
    return navigator.push<void>(
      _Route(
        builder: (context, animation) {
          return SearchPage(
            distance: distance,
            animation: animation,
            statusListener: statusListener,
          );
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
    return SearchViewModelBuilder(
      distance: distance,
      animation: animation,
      statusListener: statusListener,
    );
  }
}
