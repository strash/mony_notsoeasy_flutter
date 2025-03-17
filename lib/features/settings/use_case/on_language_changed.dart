import "package:flutter/widgets.dart" show BuildContext;
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/domain/services/local_storage/shared_preferences.dart";
import "package:mony_app/features/settings/page/view_model.dart";
import "package:provider/provider.dart";

final class OnLanguageChanged extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    final viewModel = context.viewModel<SettingsViewModel>();
    final sharedPrefService = context.read<DomainSharedPreferencesService>();

    final value = viewModel.language.rotate;
    await value.setLocale();
    await sharedPrefService.setSettingsLanguage(value);

    viewModel.setProtectedState(() {
      viewModel.language = value;
    });
  }
}
