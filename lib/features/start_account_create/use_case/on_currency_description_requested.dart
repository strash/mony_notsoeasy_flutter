import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:sealed_currencies/sealed_currencies.dart";

final class OnCurrencyDescriptionRequested
    extends UseCase<String, FiatCurrency> {
  @override
  String call(BuildContext context, [FiatCurrency? currency]) {
    if (currency == null) return "";
    late final locale = Localizations.localeOf(context);
    late final lang = NaturalLanguage.maybeFromCodeShort(locale.countryCode);
    final symbol = currency.symbol ?? "";
    if (lang != null) {
      final base = BasicLocale(lang);
      return "${currency.maybeTranslation(base)} $symbol";
    }
    return "${currency.name} $symbol";
  }
}
