part of "./view_model.dart";

enum ESearchPage implements IDescriptable {
  accounts,
  categories,
  tags,
  ;

  String get icon {
    return switch (this) {
      ESearchPage.accounts => Assets.icons.widgetSmall,
      ESearchPage.categories => Assets.icons.arrowUpArrowDownSquare,
      ESearchPage.tags => Assets.icons.number,
    };
  }

  @override
  String get description {
    return switch (this) {
      ESearchPage.accounts => "Счета",
      ESearchPage.categories => "Категории",
      ESearchPage.tags => "Теги",
    };
  }
}

enum ESearchTab implements IDescriptable {
  top,
  accounts,
  categories,
  tags,
  ;

  static const ESearchTab defaultValue = top;

  @override
  String get description {
    return switch (this) {
      top => "Топ",
      accounts => "Счет",
      categories => "Категория",
      tags => "Тег",
    };
  }
}