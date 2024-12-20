import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/search/page/view_model.dart";

final class OnPagePressed extends UseCase<Future<void>, ESearchPage> {
  @override
  Future<void> call(BuildContext context, [ESearchPage? value]) async {
    if (value == null) throw ArgumentError.notNull();

    print(value);
  }
}
