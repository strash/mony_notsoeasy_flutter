import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/common/extensions/double.dart";
import "package:mony_app/domain/models/account.dart";
import "package:mony_app/domain/models/account_balance.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/domain/services/database/vo/account.dart";
import "package:mony_app/features/account_form/page/view_model.dart";

final class OnInit extends UseCase<Future<void>, AccountFormViewModel> {
  @override
  Future<void> call(
    BuildContext context, [
    AccountFormViewModel? viewModel,
  ]) async {
    if (viewModel == null) throw ArgumentError.notNull();

    final service = context.service<DomainAccountService>();
    final data = await Future.wait(
      EAccountType.values.map((e) => service.getAll(type: e)),
    );
    // set balance to total sum
    if (viewModel.account case AccountVariantModel(:final model)) {
      final balance = await service.getBalance(id: model.id);
      if (balance != null) {
        viewModel.balanceController.text =
            balance.totalSum.roundToFraction(2).toString();
      }
    }
    for (final list in data) {
      if (list.isEmpty) continue;
      // exclude model from list
      if (viewModel.account case AccountVariantModel(:final model)) {
        viewModel.titles[list.first.type] = List<String>.from(
          list.where((e) => e.id != model.id).map((e) => e.title),
        );
      } else {
        viewModel.titles[list.first.type] = List<String>.from(
          list.map((e) => e.title),
        );
      }
    }
    // append additional user titles
    for (final element in viewModel.additionalUsedTitles.entries) {
      viewModel.titles[element.key] = List<String>.from(
        viewModel.titles[element.key]!,
      )..addAll(element.value);
    }
    viewModel.updateTitleController();
  }
}
