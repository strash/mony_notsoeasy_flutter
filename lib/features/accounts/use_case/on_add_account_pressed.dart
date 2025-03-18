import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/services/database/account.dart";
import "package:mony_app/domain/services/database/vo/account.dart";
import "package:mony_app/features/account_form/page/view_model.dart";

final class OnAddAccountPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final accountService = context.service<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return AccountFormPage(
          keyboardHeight: bottom,
          account: null,
          additionalUsedTitles: const {},
        );
      },
    );

    if (result == null) return;

    final account = await accountService.create(vo: result);
    appService.notify(EventAccountCreated(account));
  }
}
