enum EImportColumn {
  account,
  amount,
  expenseType,
  date,
  category,
  tag,
  note,
  ;

  static EImportColumn get defaultValue => account;

  static EImportColumn? from(int index) {
    return values.elementAtOrNull(index);
  }
}

extension EImportColumnEx on EImportColumn {
  bool get isRequired {
    return this == EImportColumn.amount ||
        this == EImportColumn.date ||
        this == EImportColumn.category;
  }

  String get title {
    return switch (this) {
      EImportColumn.account => "Счет",
      EImportColumn.amount => "Сумма транзакции",
      EImportColumn.expenseType => "Тип транзакции",
      EImportColumn.date => "Дата транзакции",
      EImportColumn.category => "Категория транзакции",
      EImportColumn.tag => "Тег транзакции",
      EImportColumn.note => "Заметка транзакции",
    };
  }

  String get shortTitle {
    return switch (this) {
      EImportColumn.account => "Счет",
      EImportColumn.amount => "Сумма",
      EImportColumn.expenseType => "Тип",
      EImportColumn.date => "Дата",
      EImportColumn.category => "Категория",
      EImportColumn.tag => "Тег",
      EImportColumn.note => "Заметка",
    };
  }
}
