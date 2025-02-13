import "package:intl/intl.dart";

/// Word case hint. Makes sense only for Russian language.
///
/// - `nominative`: 1 год, месяц, день, программа и тд,
/// - `genitive`: 2 года, месяца, дня, программы и тд,
/// - `accusative`: 5 лет, месяцев, дней, программ и тд.
enum EWordCaseHint { nominative, genitive, accusative }

extension IntEx on int {
  String transactionsCountDescription(String locale) {
    final formatter = NumberFormat.decimalPattern(locale);
    final formattedCount = formatter.format(this);

    return switch (wordCaseHint) {
      EWordCaseHint.nominative => "$formattedCount транзакция за все время",
      EWordCaseHint.genitive => "$formattedCount транзакции за все время",
      EWordCaseHint.accusative => "$formattedCount транзакций за все время",
    };
  }

  /// Returns wrapped value between `min` inclusive and `max` exclusive.
  ///
  /// Example:
  /// ```dart
  /// // will print 2
  /// print(10.wrapi(0, 8));
  /// ```
  int wrapi(int min, int max) {
    final range = max - min;
    return range == 0 ? min : min + ((((this - min) % range) + range) % range);
  }

  /// Returns [EWordCaseHint] for the number. Makes sense only for Russian
  /// language.
  ///
  /// - `nominative`: 1 год, месяц, день, программа и тд,
  /// - `genitive`: 2 года, месяца, дня, программы и тд,
  /// - `accusative`: 5 лет, месяцев, дней, программ и тд.
  EWordCaseHint get wordCaseHint {
    final remTen = remainder(10);
    final remHun = remainder(100);
    if (remTen == 1 && remHun != 11) return EWordCaseHint.nominative;
    if (remTen > 1 && remTen < 5) {
      if (remHun < 10 || remHun >= 10 && (remHun < 12 || remHun > 14)) {
        return EWordCaseHint.genitive;
      }
    }
    return EWordCaseHint.accusative;
  }
}
