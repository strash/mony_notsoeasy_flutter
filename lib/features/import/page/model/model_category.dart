part of "./base_model.dart";

typedef _TListVO = List<ImportModelCategoryVO>;
typedef _TMappedCategories = Map<ImportModelTransactionTypeVO, _TListVO>;

final class ImportModelCategory extends ImportModel {
  final ImportModelTransactionType typeModel;
  final mappedCategories = ValueNotifier<_TMappedCategories>(const {});

  ImportModelCategory({required this.typeModel}) {
    mappedCategories.value = _mapCategories();
  }

  Map<ImportModelTransactionTypeVO, List<ImportModelCategoryVO>>
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
          return ImportModelCategoryVOEmpty(
            originalTitle: e,
            transactionType: entry.transactionType,
          );
        }).toList(growable: false),
    };
  }

  String get numberOfCategoriesDescription {
    final count = mappedCategories.value.entries
        .fold<int>(0, (prev, curr) => prev + curr.value.length);
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted категория",
      EWordCaseHint.genitive => "$formatted категории",
      EWordCaseHint.accusative => "$formatted категорий",
    };
  }

  List<String> getTitles(ImportModelCategoryVOVO category) {
    for (final MapEntry(key: type, value: list)
        in mappedCategories.value.entries) {
      if (type.transactionType == category.transactionType) {
        return list
            .whereType<ImportModelCategoryVOVO>()
            .where((e) => e.vo != category.vo)
            .map((e) => e.vo.title)
            .toList(growable: false);
      }
    }
    return const [];
  }

  void remap(ImportModelCategoryVO category) {
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
      mapped[type] = List<ImportModelCategoryVO>.from(list)
        ..removeAt(index)
        ..insert(index, category);
      mappedCategories.value = mapped;
      break;
    }
  }

  @override
  bool isReady() {
    return mappedCategories.value.entries.every(
      (e) => e.value.every((c) => c is! ImportModelCategoryVOEmpty),
    );
  }

  @override
  void dispose() {
    mappedCategories.dispose();
  }
}

sealed class ImportModelCategoryVO {
  final String originalTitle;
  final ETransactionType transactionType;

  ImportModelCategoryVO({
    required this.originalTitle,
    required this.transactionType,
  });

  ImportModelCategoryVOEmpty toEmpty() {
    return ImportModelCategoryVOEmpty(
      originalTitle: originalTitle,
      transactionType: transactionType,
    );
  }
}

final class ImportModelCategoryVOEmpty extends ImportModelCategoryVO {
  ImportModelCategoryVOEmpty({
    required super.originalTitle,
    required super.transactionType,
  });

  ImportModelCategoryVOVO toVO({required CategoryVO vo}) {
    return ImportModelCategoryVOVO(
      originalTitle: originalTitle,
      transactionType: transactionType,
      vo: vo,
    );
  }

  ImportModelCategoryVOModel toModel({required CategoryModel model}) {
    return ImportModelCategoryVOModel(
      originalTitle: originalTitle,
      transactionType: transactionType,
      model: model,
    );
  }
}

final class ImportModelCategoryVOModel extends ImportModelCategoryVO {
  final CategoryModel model;

  ImportModelCategoryVOModel({
    required super.originalTitle,
    required super.transactionType,
    required this.model,
  });

  ImportModelCategoryVOModel copyWith({required CategoryModel model}) {
    return ImportModelCategoryVOModel(
      originalTitle: originalTitle,
      transactionType: transactionType,
      model: model,
    );
  }
}

final class ImportModelCategoryVOVO extends ImportModelCategoryVO {
  final CategoryVO vo;

  ImportModelCategoryVOVO({
    required super.originalTitle,
    required super.transactionType,
    required this.vo,
  });

  ImportModelCategoryVOVO copyWith({required CategoryVO vo}) {
    return ImportModelCategoryVOVO(
      originalTitle: originalTitle,
      transactionType: transactionType,
      vo: vo,
    );
  }
}
