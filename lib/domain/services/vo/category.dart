import "package:flutter/rendering.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:mony_app/domain/models/transaction.dart";

part "category.freezed.dart";

@freezed
class CategoryVO with _$CategoryVO {
  const factory CategoryVO({
    required String title,
    required String icon,
    required int sort,
    required Color color,
    required ETransactionType transactionType,
  }) = _CategoryVO;
}