import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:provider/provider.dart";

final class OnTransactionTypeToggled extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final sharedPrefService = context.read<DomainSharedPreferencesService>();
    final appService = context.viewModel<AppEventService>();

    final currValue =
        await sharedPrefService.getSettingsDefaultTransactionType();
    final value = ETransactionType.values.elementAt(
      (currValue.index + 1).wrapi(0, ETransactionType.values.length),
    );

    await sharedPrefService.setSettingsDefaultTransactionType(value);

    appService.notify(
      EventSettingsDefaultTransactionTypeChanged(value),
    );
  }
}
