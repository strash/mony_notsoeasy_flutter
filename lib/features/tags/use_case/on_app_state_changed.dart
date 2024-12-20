import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/tags/page/view_model.dart";

typedef _TValue = ({Event event, TagsViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
