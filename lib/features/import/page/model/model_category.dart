part of "./base_model.dart";

typedef _TListVO = List<ImportModelCategoryVariant>;
typedef _TMappedCategories = Map<ImportModelTransactionTypeVO, _TListVO>;

final class ImportModelCategory extends ImportModel {
  final ImportModelTransactionType typeModel;
  final mappedCategories = ValueNotifier<_TMappedCategories>(const {});

  ImportModelCategory({required this.typeModel}) {
    mappedCategories.value = _mapCategories();
  }

  Map<ImportModelTransactionTypeVO, List<ImportModelCategoryVariant>>
      _mapCategories() {
    return {
      for (final entry in typeModel.mappedEntriesByType)
        entry: Set<String>.from(
          entry.entries
              .map(
                (e) => e.entries
                    .where((c) => c.key.column == EImportColumn.category)
                    .map((c) => c.value)
                    .toList(growable: false),
              )
              .toList(growable: false)
              .foldValue([], (prev, curr) => [...prev ?? [], ...curr]),
        ).map((e) {
          return ImportModelCategoryVariantEmpty(
            originalTitle: e,
            transactionType: entry.transactionType,
          );
        }).toList(growable: false),
    };
  }

  String numberOfCategoriesDescription(String locale) {
    final count = mappedCategories.value.entries
        .fold<int>(0, (prev, curr) => prev + curr.value.length);
    final formatter = NumberFormat.decimalPattern(locale);
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted категория",
      EWordCaseHint.genitive => "$formatted категории",
      EWordCaseHint.accusative => "$formatted категорий",
    };
  }

  List<String> getTitles(ImportModelCategoryVariantVO category) {
    for (final MapEntry(key: type, value: list)
        in mappedCategories.value.entries) {
      if (type.transactionType == category.transactionType) {
        return list
            .whereType<ImportModelCategoryVariantVO>()
            .where((e) => e.vo != category.vo)
            .map((e) => e.vo.title)
            .toList(growable: false);
      }
    }
    return const [];
  }

  void remap(ImportModelCategoryVariant category) {
    for (final MapEntry(key: type, value: list)
        in mappedCategories.value.entries) {
      if (type.transactionType != category.transactionType) continue;
      final index = list.indexWhere((e) {
        return e.originalTitle == category.originalTitle &&
            e.transactionType == category.transactionType;
      });
      if (index == -1) break;
      final mapped = Map<ImportModelTransactionTypeVO, _TListVO>.from(
        mappedCategories.value,
      );
      mapped[type] = List<ImportModelCategoryVariant>.from(list)
        ..removeAt(index)
        ..insert(index, category);
      mappedCategories.value = mapped;
      break;
    }
  }

  @override
  bool isReady() {
    return mappedCategories.value.entries.every(
      (e) => e.value.every((c) => c is! ImportModelCategoryVariantEmpty),
    );
  }

  @override
  void dispose() {
    mappedCategories.dispose();
  }
}

sealed class ImportModelCategoryVariant {
  final String originalTitle;
  final ETransactionType transactionType;

  ImportModelCategoryVariant({
    required this.originalTitle,
    required this.transactionType,
  });

  ImportModelCategoryVariantEmpty toEmpty() {
    return ImportModelCategoryVariantEmpty(
      originalTitle: originalTitle,
      transactionType: transactionType,
    );
  }
}

final class ImportModelCategoryVariantEmpty extends ImportModelCategoryVariant {
  ImportModelCategoryVariantEmpty({
    required super.originalTitle,
    required super.transactionType,
  });

  ImportModelCategoryVariantVO toVO({required CategoryVO vo}) {
    return ImportModelCategoryVariantVO(
      originalTitle: originalTitle,
      transactionType: transactionType,
      vo: vo,
    );
  }

  ImportModelCategoryVariantModel toModel({required CategoryModel model}) {
    return ImportModelCategoryVariantModel(
      originalTitle: originalTitle,
      transactionType: transactionType,
      model: model,
    );
  }
}

final class ImportModelCategoryVariantModel extends ImportModelCategoryVariant {
  final CategoryModel model;

  ImportModelCategoryVariantModel({
    required super.originalTitle,
    required super.transactionType,
    required this.model,
  });

  ImportModelCategoryVariantModel copyWith({required CategoryModel model}) {
    return ImportModelCategoryVariantModel(
      originalTitle: originalTitle,
      transactionType: transactionType,
      model: model,
    );
  }
}

final class ImportModelCategoryVariantVO extends ImportModelCategoryVariant {
  final CategoryVO vo;

  ImportModelCategoryVariantVO({
    required super.originalTitle,
    required super.transactionType,
    required this.vo,
  });

  ImportModelCategoryVariantVO copyWith({required CategoryVO vo}) {
    return ImportModelCategoryVariantVO(
      originalTitle: originalTitle,
      transactionType: transactionType,
      vo: vo,
    );
  }
}
