import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/domain/domain.dart";

part "./event.dart";

final class AppEventServiceBuilder extends StatefulWidget {
  final Widget child;

  const AppEventServiceBuilder({super.key, required this.child});

  @override
  ViewModelState<AppEventServiceBuilder> createState() => AppEventService();
}

final class AppEventService extends ViewModelState<AppEventServiceBuilder> {
  final _subject = StreamController<Event>.broadcast();

  Stream<Event> get stream => _subject.stream;

  StreamSubscription<Event> listen(void Function(Event event) onData) {
    return _subject.stream.listen(onData);
  }

  void notify(Event event) {
    _subject.add(event);
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<AppEventService>(viewModel: this, child: widget.child);
  }
}
