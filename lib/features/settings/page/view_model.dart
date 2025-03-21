import "dart:async";

import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/navbar/navbar.dart";
import "package:mony_app/features/settings/page/view.dart";
import "package:mony_app/features/settings/use_case/use_case.dart";
import "package:mony_app/i18n/strings.g.dart" show AppLocale, LocaleSettings;

enum ESettingsLanguage {
  system(value: "system"),
  english(value: "english"),
  russian(value: "russian");

  final String value;

  const ESettingsLanguage({required this.value});

  static ESettingsLanguage get defaultValue => system;

  static ESettingsLanguage from(String value) {
    return values.where((e) => e.value == value).firstOrNull ?? defaultValue;
  }

  ESettingsLanguage get rotated {
    return values.elementAt((index + 1).wrapi(0, values.length));
  }

  Future<void> setLocale() async {
    switch (this) {
      case ESettingsLanguage.system:
        await LocaleSettings.useDeviceLocale();
      case ESettingsLanguage.english:
        await LocaleSettings.setLocale(AppLocale.en);
      case ESettingsLanguage.russian:
        await LocaleSettings.setLocale(AppLocale.ru);
    }
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  ViewModelState<SettingsPage> createState() => SettingsViewModel();
}

final class SettingsViewModel extends ViewModelState<SettingsPage> {
  late final StreamSubscription<Event> _appSub;
  late final StreamSubscription<NavBarEvent> _navbarSub;

  final scrollController = ScrollController();

  ThemeMode themeMode = ThemeMode.system;
  bool isColorsVisible = true;
  bool isCentsVisible = true;
  bool isTagsVisible = true;
  ETransactionType defaultTransactionType = ETransactionType.defaultValue;
  bool confirmTransaction = true;
  bool confirmAccount = true;
  bool confirmCategory = true;
  bool confirmTag = true;
  ESettingsLanguage language = ESettingsLanguage.defaultValue;

  bool isImportInProgress = false;

  void _onAppEvent(Event event) {
    if (!mounted) return;
    OnAppStateChanged().call(context, (event: event, viewModel: this));
  }

  void _onNavBarEvent(NavBarEvent e) {
    if (!context.mounted) return;
    final navBar = context.viewModel<NavBarViewModel>();
    if (navBar.currentTab != ENavBarTabItem.settings) return;

    switch (e) {
      case NavBarEventTabChanged():
        break;
      case NavBarEventScrollToTopRequested():
        // -> scroll to top
        if (scrollController.isReady && scrollController.position.pixels > .0) {
          navBar.returnToTop(scrollController);
        }
      case NavBarEventAddTransactionPressed():
        OnNavbarAddTransactionPressed().call(context, this);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timastamp) async {
      // -> app events
      _appSub = context.viewModel<AppEventService>().listen(_onAppEvent);

      // -> navbar
      _navbarSub = context.viewModel<NavBarViewModel>().subject.listen(
        _onNavBarEvent,
      );

      final sharedPrefService =
          context.service<DomainSharedPreferencesService>();
      final mode = await sharedPrefService.getSettingsThemeMode();
      final colors = await sharedPrefService.isSettingsColorsVisible();
      final cents = await sharedPrefService.isSettingsCentsVisible();
      final tags = await sharedPrefService.isSettingsTagsVisible();
      final transactionType =
          await sharedPrefService.getSettingsDefaultTransactionType();
      final confTransaction =
          await sharedPrefService.getSettingsConfirmTransaction();
      final confAccount = await sharedPrefService.getSettingsConfirmAccount();
      final confCategory = await sharedPrefService.getSettingsConfirmCategory();
      final confTag = await sharedPrefService.getSettingsConfirmTag();
      final lang = await sharedPrefService.getSettingsLanguage();
      await lang.setLocale();
      setProtectedState(() {
        themeMode = mode;
        isColorsVisible = colors;
        isCentsVisible = cents;
        isTagsVisible = tags;
        defaultTransactionType = transactionType;
        confirmTransaction = confTransaction;
        confirmAccount = confAccount;
        confirmCategory = confCategory;
        confirmTag = confTag;
        language = lang;
      });
    });
  }

  @override
  void dispose() {
    _appSub.cancel();
    _navbarSub.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModel<SettingsViewModel>(
      viewModel: this,
      useCases: [
        () => OnThemeModePressed(),
        () => OnColorsToggled(),
        () => OnCentsToggled(),
        () => OnTagsToggled(),
        () => OnTransactionTypeToggled(),
        () => OnConfirmTransactionToggled(),
        () => OnConfirmAccountToggled(),
        () => OnConfirmCategoryToggled(),
        () => OnConfirmTagToggled(),
        () => OnImportDataPressed(),
        () => OnExportDataPressed(),
        () => OnReviewPressed(),
        () => OnSupportPressed(),
        () => OnLanguageChanged(),
        () => OnPrivacyPolicyPressed(),
        () => OnDeleteDataPressed(),
      ],
      child: const SettingsView(),
    );
  }
}
