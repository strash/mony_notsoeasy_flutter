import "package:intl/intl.dart";
import "package:mony_app/common/extensions/extensions.dart";

extension DateRangeEx on ({DateTime? lhs, DateTime? rhs}) {
  String get transactionsDateRangeDescription {
    final now = DateTime.now();
    switch ((lhs, rhs)) {
      case (null, final DateTime rhs):
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
        );
        return rhsFormatter.format(rhs);
      case (final DateTime lhs, null):
        final lhsFormatter = DateFormat(
          now.year != lhs.year ? "EEE, dd MMMM yyyy" : "EEE, dd MMMM",
        );
        return lhsFormatter.format(lhs);
      case (final DateTime lhs, final DateTime rhs):
        String lhsPattern = "dd";
        if (lhs.month != rhs.month || lhs.year != rhs.year) {
          lhsPattern += " MMMM";
        }
        if (now.year != lhs.year && lhs.year != rhs.year) lhsPattern += " yyyy";
        final lhsFormatter = DateFormat(lhsPattern);
        final rhsFormatter = DateFormat(
          now.year != rhs.year ? "dd MMMM yyyy" : "dd MMMM",
        );
        if (lhs.isSameDateAs(rhs)) return rhsFormatter.format(rhs);
        return "${lhsFormatter.format(lhs)}—${rhsFormatter.format(rhs)}";
      default:
        return "";
    }
  }
}
