import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnSelectedColumnNameRequestedUseCase
    extends BaseValueUseCase<String, String?> {
  @override
  String? action(BuildContext context, String value) {
    final viewModel = context.viewModel<StartAccountImportViewModel>();
    final columns = viewModel.mappedCsvColumns;
    if (columns.account == value) {
      return "Счет";
    } else if (columns.amount == value) {
      return "Сумма";
    } else if (columns.expenseType == value) {
      return "Тип";
    } else if (columns.date == value) {
      return "Дата";
    } else if (columns.category == value) {
      return "Категория";
    } else if (columns.tag == value) {
      return "Тэг";
    } else if (columns.note == value) {
      return "Заметка";
    }
    return null;
  }
}
