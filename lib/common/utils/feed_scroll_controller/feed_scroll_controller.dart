import "dart:async";

import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:rxdart/rxdart.dart";

final class FeedScrollControllerEvent {}

final class FeedScrollController {
  final controller = ScrollController();
  double distance = .0;

  final _subject = BehaviorSubject<FeedScrollControllerEvent>();

  final VoidCallback? onScroll;

  FeedScrollController({this.onScroll}) {
    controller.addListener(_onScroll);
  }

  bool get isReady => controller.isReady;

  ScrollPosition get position => controller.position;

  void Function(double value) get jumpTo => controller.jumpTo;
  void Function(
    double offset, {
    required Duration duration,
    required Curve curve,
  })
  get animateTo => controller.animateTo;

  StreamSubscription<FeedScrollControllerEvent> addListener(
    void Function(FeedScrollControllerEvent) onData,
  ) {
    const duration = Duration(milliseconds: 400);
    return _subject
        .throttle((e) => TimerStream<FeedScrollControllerEvent>(e, duration))
        .listen(onData);
  }

  void _onScroll() {
    if (!isReady) return;

    distance = controller.position.pixels;
    final extent = controller.position.extentAfter;
    final direction = controller.position.userScrollDirection;

    if (direction == ScrollDirection.reverse && extent < 400.0) {
      _subject.add(FeedScrollControllerEvent());
    }
    if (onScroll != null) onScroll!.call();
  }

  void dispose() {
    _subject.close();
    controller.removeListener(_onScroll);
    controller.dispose();
  }
}
