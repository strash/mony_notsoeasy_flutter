import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/features/features.dart";

final class OnAccountPressed extends UseCase<void, FeedPageState> {
  @override
  void call(BuildContext context, [FeedPageState? pageState]) {
    if (pageState == null) throw ArgumentError.notNull();

    switch (pageState) {
      // TODO: open account list page
      case FeedPageStateAllAccounts():
        break;
      // open one account page
      case FeedPageStateSingleAccount(:final account):
        context.go<void>(AccountPage(account: account));
    }
  }
}