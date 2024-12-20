import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/features/accounts/page/view_model.dart";

typedef _TValue = ({Event event, AccountsViewModel viewModel});

final class OnAppStateCnanged extends UseCase<Future<void>, _TValue> {
  @override
  Future<void> call(BuildContext context, [_TValue? value]) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
