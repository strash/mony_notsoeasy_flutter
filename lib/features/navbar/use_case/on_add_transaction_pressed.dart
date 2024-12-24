import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/navbar/navbar.dart";

final class OnAddTransactionPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<NavBarViewModel>();
    viewModel.subject.add(NavBarEventAddTransactionPressed());
  }
}
