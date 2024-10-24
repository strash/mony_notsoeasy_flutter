import "dart:ui";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/models/transaction.dart";

part "category.freezed.dart";

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required String title,
    required String icon,
    required int sort,
    required Color color,
    required ETransactionType transactionType,
  }) = _CategoryModel;
}
