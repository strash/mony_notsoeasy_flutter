enum EImportColumn {
  amount,
  date,
  category,
  transactionType,
  account,
  tag,
  note;

  static EImportColumn get defaultValue => amount;

  static EImportColumn? from(int index) {
    return values.elementAtOrNull(index);
  }

  EImportColumn? get next {
    return values.elementAtOrNull(index + 1);
  }

  bool get isRequired {
    return this == EImportColumn.amount ||
        this == EImportColumn.date ||
        this == EImportColumn.category;
  }
}
