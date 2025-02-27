import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/search/page/view_model.dart";

final class OnSearchPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [_]) {
    SearchPage.show(context);
  }
}
