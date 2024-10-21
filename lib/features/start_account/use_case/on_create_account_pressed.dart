import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/services/services.dart";
import "package:mony_app/features/account_form/page/page.dart";
import "package:provider/provider.dart";

final class OnCreateAccountPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final result = await BottomSheetComponent.show<AccountVO?>(
      context,
      initialChildSize: 1.0,
      expand: false,
      showDragHandle: false,
      builder: (context, scrollController) {
        return AccountFormPage(scrollController: scrollController);
      },
    );
    if (result == null || !context.mounted) return;
    final accountService = context.read<AccountService>();
    final eventService = context.viewModel<AppEventService>();
    final account = await accountService.create(result);
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      eventService.notify(
        EventAccountCreated(
          sender: AccountFormViewModel,
          account: account,
        ),
      );
    }
  }
}
