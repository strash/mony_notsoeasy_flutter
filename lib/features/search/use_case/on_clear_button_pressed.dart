import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/search/page/view_model.dart";

final class OnClearButtonPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [_]) {
    final viewModel = context.viewModel<SearchViewModel>();

    viewModel.input.text = "";
  }
}
