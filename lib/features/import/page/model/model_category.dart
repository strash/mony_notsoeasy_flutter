part of "./base_model.dart";

final class ImportModelCategory extends ImportModel {
  final ImportModelTransactionType typeModel;
  Map<ImportModelTransactionTypeVO, List<ImportModelCategoryVO>>
      mappedCategories = const {};

  ImportModelCategory({required this.typeModel}) {
    mappedCategories = _mapCategories();
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
        )
            .map((e) => ImportModelCategoryVOEmpty(title: e))
            .toList(growable: false),
    };
  }

  String get numberOfCategoriesDescription {
    final count = mappedCategories.entries
        .fold<int>(0, (prev, curr) => prev + curr.value.length);
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(count);
    return switch (count.wordCaseHint) {
      EWordCaseHint.nominative => "$formatted категория",
      EWordCaseHint.genitive => "$formatted категории",
      EWordCaseHint.accusative => "$formatted категорий",
    };
  }

  @override
  bool isReady() {
    return mappedCategories.entries.every(
      (e) => e.value.every(
        (c) => switch (c) {
          final ImportModelCategoryVOModel model => model.model != null,
          final ImportModelCategoryVOVO vo => vo.vo != null,
          ImportModelCategoryVOEmpty() => false,
        },
      ),
    );
  }

  @override
  void dispose() {}
}

sealed class ImportModelCategoryVO {
  final String title;

  ImportModelCategoryVO({required this.title});
}

final class ImportModelCategoryVOEmpty extends ImportModelCategoryVO {
  ImportModelCategoryVOEmpty({required super.title});
}

final class ImportModelCategoryVOModel extends ImportModelCategoryVO {
  final CategoryModel? model;

  ImportModelCategoryVOModel({required super.title, required this.model});
}

final class ImportModelCategoryVOVO extends ImportModelCategoryVO {
  final CategoryVO? vo;

  ImportModelCategoryVOVO({required super.title, required this.vo});
}
