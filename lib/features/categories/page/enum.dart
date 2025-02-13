import "package:mony_app/gen/assets.gen.dart";

enum ECategoriesMenuItem {
  addExpenseCategory,
  addIncomeCategory;

  String get description {
    return switch (this) {
      addExpenseCategory => "Категория расходов",
      addIncomeCategory => "Категория доходов",
    };
  }

  String get icon {
    return switch (this) {
      addExpenseCategory => Assets.icons.arrowUpForward,
      addIncomeCategory => Assets.icons.arrowDownForward,
    };
  }
}
