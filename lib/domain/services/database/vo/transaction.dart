final class TransactionVO {
  final double amout;
  final DateTime date;
  final String note;
  final String accountId;
  final String categoryId;

  const TransactionVO({
    required this.amout,
    required this.date,
    required this.note,
    required this.accountId,
    required this.categoryId,
  });
}
