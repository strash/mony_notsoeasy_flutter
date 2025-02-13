import "package:mony_app/app/descriptable/descriptable.dart";

enum EImportColumn implements IDescriptable {
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

  String get title {
    return switch (this) {
      EImportColumn.account => "Счет",
      EImportColumn.amount => "Сумма",
      EImportColumn.transactionType => "Тип транзакции",
      EImportColumn.date => "Дата",
      EImportColumn.category => "Категория",
      EImportColumn.tag => "Тег",
      EImportColumn.note => "Заметка",
    };
  }

  @override
  String get description {
    return switch (this) {
      EImportColumn.account =>
        "В этой колонке должно быть название счета, "
            "к которому привязана транзакция. Эта колонка не обязательна и ее "
            "можно пропустить. Чуть позже можно будет создать новый счет.",
      EImportColumn.amount =>
        "В этой колонке должна быть сумма транзакции. "
            "Колонка не должна содержать запятых и символов/названий валют. "
            "Может содержать только цифры, точку и знаки +/-. Колонка обязательна.",
      EImportColumn.transactionType =>
        "В этой колонке может быть только два "
            "возможных значения: expense (трата) или income (доход). Могут "
            "называться иначе. Колонка не обязательна и ее можно пропустить. "
            "В этом случае будет произведена попытка понять тип транзакции из "
            "суммы транзакции. Если сумма содержит минус, значит это трата.",
      EImportColumn.date =>
        "Это обязательная колонка и она должна содержать "
            "дату, которая может выглядет следующим образом:\n"
            " - 2012-02-27\n"
            " - 2012-02-27 13:27:00\n"
            " - 2012-02-27 13:27:00.123456789z\n"
            " - 2012-02-27 13:27:00,123456789z\n"
            " - 20120227 13:27:00\n"
            " - 20120227T132700\n"
            " - 20120227\n"
            " - +20120227\n"
            " - 2012-02-27T14Z\n"
            " - 2012-02-27T14+00:00\n"
            " - -123450101 00:00:00 Z\n"
            " - 2002-02-27T14:00:00-0500\n"
            " - 2002-02-27T19:00:00Z\n"
            " - 2002-02-27 14:00:00 +0000\n",
      EImportColumn.category =>
        "В этой колонке должен быть обычный текст, "
            "скорее всего состоящий из одного слова. Это колонка обязательна. "
            "У одной транзакции может быть только одна категория. Для расходов "
            "и доходов должны быть разные категории. Текст не должен содержать "
            "запятых.",
      EImportColumn.tag =>
        "В этой колонке должен быть обычный текст, "
            "скорее всего состоящий из одного слова. В некоторых транзакциях "
            "она может быть пустой, так как необязательна. Тег это что-то "
            "вроде подгатегории. Текст в нем не должен содержать запятых.",
      EImportColumn.note =>
        "В этой колонке может быть обычный текст, "
            "описывающий транзакцию в свободной форме. В тексте не должно быть "
            "запятых.",
    };
  }
}
