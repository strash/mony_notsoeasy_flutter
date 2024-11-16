part of "./base_model.dart";

final class ImportModelAccount extends ImportModel {
  final accounts = ValueNotifier<List<ImportModelAccountVO>>([]);

  bool get isFromData => accounts.value.every((e) => e.originalTitle != null);

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
