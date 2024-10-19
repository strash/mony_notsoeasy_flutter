import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnImportEventChanged
    extends UseCase<void, StartAccountImportViewModel> {
  @override
  void call(BuildContext context, [StartAccountImportViewModel? viewModel]) {
    if (viewModel == null) throw ArgumentError.notNull();
    viewModel.subject.listen((event) {
      viewModel.setProtectedState(() {
        if (event case ImportEventMapAccount()) {
          viewModel.currentColumn = "Счет";
        } else if (event case ImportEventMapAmount()) {
          viewModel.currentColumn = "Сумма транзакции";
        } else if (event case ImportEventMapExpenseType()) {
          viewModel.currentColumn = "Тип транзакции";
        } else if (event case ImportEventMapDate()) {
          viewModel.currentColumn = "Дата транзакции";
        } else if (event case ImportEventMapCategory()) {
          viewModel.currentColumn = "Категория транзакции";
        } else if (event case ImportEventMapTag()) {
          viewModel.currentColumn = "Тег транзакции";
        } else if (event case ImportEventMapNote()) {
          viewModel.currentColumn = "Заметка транзакции";
        }
      });
    });
  }
}
