import "package:mony_app/domain/models/transaction.dart";

final class CategoryVO {
  final String title;
  final String icon;
  final int sort;
  final String colorName;
  final ETransactionType transactionType;

  const CategoryVO({
    required this.title,
    required this.icon,
    required this.sort,
    required this.colorName,
    required this.transactionType,
  });
}
