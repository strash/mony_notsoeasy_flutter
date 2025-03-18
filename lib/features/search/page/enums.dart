import "package:mony_app/gen/assets.gen.dart";

enum ESearchPage {
  accounts,
  categories,
  tags;

  String get icon {
    return switch (this) {
      ESearchPage.accounts => Assets.icons.widgetSmall,
      ESearchPage.categories => Assets.icons.arrowUpArrowDownSquare,
      ESearchPage.tags => Assets.icons.number,
    };
  }
}

enum ESearchTab {
  // top,
  transactions,
  accounts,
  categories,
  tags;

  static const ESearchTab defaultValue = transactions;
}
