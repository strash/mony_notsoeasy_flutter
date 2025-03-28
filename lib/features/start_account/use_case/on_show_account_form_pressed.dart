import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/account_form/account_form.dart";

final class OnShowAccountFormPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
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
    if (result == null || !context.mounted) return;
    final accountService = context.service<DomainAccountService>();
    final eventService = context.viewModel<AppEventService>();
    final account = await accountService.create(vo: result);
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      eventService.notify(EventAccountCreated(account));
    }
  }
}
