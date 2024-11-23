import "package:mony_app/app/descriptable/descriptable.dart";

enum ETransactionType implements IDescriptable {
  expense(value: "expense"),
  income(value: "income"),
  ;

  final String value;

  const ETransactionType({required this.value});

  static ETransactionType get defaultValue => expense;

  static ETransactionType from(String type) {
    return values.where((e) => e.value == type).firstOrNull ?? defaultValue;
  }

  ETransactionType get toggle {
    return switch (this) {
      expense => income,
      income => expense,
    };
  }

  @override
  String get description {
    return switch (this) {
      expense => "Расход",
      income => "Доход",
    };
  }

  String get fullDescription {
    return switch (this) {
      ETransactionType.expense => "Категория расходов",
      ETransactionType.income => "Категория доходов",
    };
  }
}
