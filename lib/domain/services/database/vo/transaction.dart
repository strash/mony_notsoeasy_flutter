final class TransactionVO {
  final String? id;
  final DateTime? created;
  final DateTime? updated;
  final double amount;
  final DateTime date;
  final String note;
  final String accountId;
  final String categoryId;

  const TransactionVO({
    this.id,
    this.created,
    this.updated,
    required this.amount,
    required this.date,
    required this.note,
    required this.accountId,
    required this.categoryId,
  });

  static TransactionVO? from(Map<String, dynamic> map) {
    final String? id = map["id"] as String?;
    final String? created = map["created"] as String?;
    final String? updated = map["updated"] as String?;
    final double? amount = map["amount"] as double?;
    final String? date = map["date"] as String?;
    final String? note = map["note"] as String?;
    final String? accountId = map["account_id"] as String?;
    final String? categoryId = map["category_id"] as String?;

    final parsedDate = DateTime.tryParse(date ?? "");

    if (id == null ||
        amount == null ||
        parsedDate == null ||
        accountId == null ||
        categoryId == null) {
      return null;
    }

    return TransactionVO(
      id: id,
      created: DateTime.tryParse(created ?? "")?.toLocal(),
      updated: DateTime.tryParse(updated ?? "")?.toLocal(),
      amount: amount,
      date: parsedDate,
      note: note ?? "",
      accountId: accountId,
      categoryId: categoryId,
    );
  }
}
