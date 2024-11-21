import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account_form/page/page.dart";
import "package:mony_app/features/feed/page/page.dart";
import "package:provider/provider.dart";

final class OnAddAccountPressed extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
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

    if (!context.mounted || result == null) return;

    final accountService = context.read<DomainAccountService>();
    final appService = context.viewModel<AppEventService>();

    final account = await accountService.create(vo: result);
    appService.notify(
      EventAccountCreated(sender: FeedViewModel, value: account),
    );
  }
}
