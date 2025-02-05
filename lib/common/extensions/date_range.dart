import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";

extension DateRangeEx on (DateTime?, DateTime?) {
  String transactionsDateRangeDescription(String locale) {
    final now = DateTime.now();
    switch (($1, $2)) {
      case (null, final DateTime rhs):
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
          locale,
        );
        return rhsFormatter.format(rhs);
      case (final DateTime lhs, null):
        final lhsFormatter = DateFormat(
          now.year != lhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
          locale,
        );
        return lhsFormatter.format(lhs);
      case (final DateTime lhs, final DateTime rhs):
        String lhsPattern = "dd";
        if (lhs.month != rhs.month || lhs.year != rhs.year) {
          lhsPattern += " MMMM";
        }
        if (now.year != lhs.year && lhs.year != rhs.year) lhsPattern += " yyyy";
        final lhsFormatter = DateFormat(lhsPattern, locale);
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "dd MMMM yyyy" : "dd MMMM",
          locale,
        );
        if (lhs.isSameDateAs(rhs)) return rhsFormatter.format(rhs);
        return "${lhsFormatter.format(lhs)}—${rhsFormatter.format(rhs)}";
      default:
        return "";
    }
  }
}
