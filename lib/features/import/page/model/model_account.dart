part of "./base_model.dart";

final class ImportModelAccount extends ImportModel {
  final accounts = ValueNotifier<List<ImportModelAccountVO>>([]);

  bool get isFromData => accounts.value.every((e) => e.originalTitle != null);

  Map<EAccountType, List<String>> getTitles(ImportModelAccountVO except) {
    final Map<EAccountType, List<String>> titles = {};
    if (isFromData) {
      for (final element in accounts.value) {
        if (element.account == null ||
            element.originalTitle == except.originalTitle) continue;
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
    final value = accounts.value;
    return value.isNotEmpty &&
        (value.every((e) => e.account != null && e.originalTitle != null) ||
            value.every((e) => e.account != null && e.originalTitle == null));
  }

  @override
  void dispose() {
    accounts.dispose();
  }
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
