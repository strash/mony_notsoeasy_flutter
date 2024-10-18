import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

typedef TOnColumnSelectedValue = ({ImportEvent event, String column});

final class OnColumnSelectedUseCase
    extends BaseValueUseCase<TOnColumnSelectedValue, void> {
  @override
  void action(BuildContext context, TOnColumnSelectedValue value) {
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    final columns = viewModel.mappedCsvColumns;
    viewModel.setProtectedState(() {
      if (value.event is ImportEventMapAccount) {
        viewModel.mappedCsvColumns = columns.copyWith(account: value.column);
      } else if (value.event is ImportEventMapAmount) {
        viewModel.mappedCsvColumns = columns.copyWith(amount: value.column);
      } else if (value.event is ImportEventMapExpenseType) {
        viewModel.mappedCsvColumns =
            columns.copyWith(expenseType: value.column);
      } else if (value.event is ImportEventMapDate) {
        viewModel.mappedCsvColumns = columns.copyWith(date: value.column);
      } else if (value.event is ImportEventMapCategory) {
        viewModel.mappedCsvColumns = columns.copyWith(category: value.column);
      } else if (value.event is ImportEventMapTag) {
        viewModel.mappedCsvColumns = columns.copyWith(tag: value.column);
      } else if (value.event is ImportEventMapNote) {
        viewModel.mappedCsvColumns = columns.copyWith(note: value.column);
      }
    });
  }
}
