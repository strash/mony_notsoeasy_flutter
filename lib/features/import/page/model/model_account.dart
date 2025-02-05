part of "./base_model.dart";

final class ImportModelAccount extends ImportModel {
  List<ImportModelAccountVO> accounts = const [];

  bool get isFromData {
    return accounts.every((e) => e.originalTitle != null);
  }

  String numberOfAccountsDescription(String locale) {
    final count = accounts.length;
    final formatter = NumberFormat.decimalPattern(locale);
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted счет",
      EWordCaseHint.genitive => "$formatted счета",
      EWordCaseHint.accusative => "$formatted счетов",
    };
  }

  Map<EAccountType, List<String>> getTitles(ImportModelAccountVO except) {
    final Map<EAccountType, List<String>> titles = {};
    if (isFromData) {
      for (final element in accounts) {
        if (element.account == null ||
            element.originalTitle == except.originalTitle) {
          continue;
        }
        if (!titles.containsKey(element.account!.type)) {
          titles[element.account!.type] = [element.account!.title];
        } else {
          titles[element.account!.type]!.add(element.account!.title);
        }
      }
    }
    return titles;
  }

  /// Either all of them have a title or theres only one and without a title.
  @override
  bool isReady() {
    final allFromDataValid = accounts.every((e) {
      return e.account != null && e.originalTitle != null;
    });
    final singleValid = accounts.every((e) {
      return e.account != null && e.originalTitle == null;
    });
    return accounts.isNotEmpty && (allFromDataValid || singleValid);
  }

  @override
  void dispose() {}
}

final class ImportModelAccountVO {
  /// If null than this is a required account and not from the data
  final String? originalTitle;
  final AccountVO? account;

  ImportModelAccountVO({
    required this.originalTitle,
    required this.account,
  });
}
