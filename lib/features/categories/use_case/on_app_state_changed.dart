import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/categories/page/view_model.dart";

typedef _TValue = ({Event event, CategoriesViewModel viewModel});

final class OnAppStateChanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) {
    // TODO: implement call
    throw UnimplementedError();
  }
}