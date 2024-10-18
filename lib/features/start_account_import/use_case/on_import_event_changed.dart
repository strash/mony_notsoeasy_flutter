import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/start_account_import/page/page.dart";

final class OnImportEventChangedUseCase
    extends BaseValueUseCase<StartAccountImportViewModel, void> {
  @override
  void action(BuildContext context, StartAccountImportViewModel value) {
    value.subject.listen((event) {
      value.setProtectedState(() {
        if (event case ImportEventMapAccount()) {
          value.currentColumn = "Счет";
        } else if (event case ImportEventMapAmount()) {
          value.currentColumn = "Сумма транзакции";
        } else if (event case ImportEventMapExpenseType()) {
          value.currentColumn = "Тип транзакции";
        } else if (event case ImportEventMapDate()) {
          value.currentColumn = "Дата транзакции";
        } else if (event case ImportEventMapCategory()) {
          value.currentColumn = "Категория транзакции";
        } else if (event case ImportEventMapTag()) {
          value.currentColumn = "Тег транзакции";
        } else if (event case ImportEventMapNote()) {
          value.currentColumn = "Заметка транзакции";
        }
      });
    });
  }
}
