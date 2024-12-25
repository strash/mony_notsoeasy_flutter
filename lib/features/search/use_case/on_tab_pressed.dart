import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/features.dart";

final class OnTabPressed extends UseCase<Future<void>, ESearchTab> {
  @override
  Future<void> call(BuildContext context, [ESearchTab? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final viewModel = context.viewModel<SearchViewModel>();

    viewModel.setProtectedState(() {
      viewModel.activeTab = value;
    });
  }
}
