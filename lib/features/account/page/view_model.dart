import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/view_model/view_model.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/components/account_with_context_menu/use_case/use_case.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/account/page/view.dart";
import "package:mony_app/features/account/use_case/use_case.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class AccountPage extends StatefulWidget {
  final AccountModel account;

  const AccountPage({super.key, required this.account});

  @override
  ViewModelState<AccountPage> createState() => AccountViewModel();
}

final class AccountViewModel extends ViewModelState<AccountPage> {
  late final StreamSubscription<Event> _appSub;

  late AccountModel account = widget.account;
  int accountsCount = 1;

  AccountBalanceModel? balance;

  bool isColorsVisible = true;

  String currencyDescription(FiatCurrency? currency) {
    if (currency == null) return "";
    final locale = Localizations.localeOf(context);
    final lang = NaturalLanguage.maybeFromCodeShort(locale.countryCode);
    if (lang != null) {
      final base = BasicLocale(lang);
      return currency.maybeTranslation(base)?.toString() ?? "";
    }
    return currency.name;
  }

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      final sharedPrefService =
          context.service<DomainSharedPreferencesService>();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      setProtectedState(() {
        isColorsVisible = colors;
      });

      if (!mounted) return;
      OnInit().call(context, this);
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<AccountViewModel>(
      viewModel: this,
      useCases: [() => OnAccountWithContextMenuSelected()],
      child: const AccountView(),
    );
  }
}
