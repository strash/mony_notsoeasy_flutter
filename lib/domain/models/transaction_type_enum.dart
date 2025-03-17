enum ETransactionType {
  expense(value: "expense"),
  income(value: "income");

  final String value;

  const ETransactionType({required this.value});

  static ETransactionType get defaultValue => expense;

  static ETransactionType from(String value) {
    return values.where((e) => e.value == value).firstOrNull ?? defaultValue;
  }

  ETransactionType get toggle {
    return switch (this) {
      expense => income,
      income => expense,
    };
  }
}
