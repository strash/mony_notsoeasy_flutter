part of "./base_model.dart";

final class ImportModelTransactionType extends ImportModel {
  final ImportModelColumnValidation validation;
  List<ImportModelTransactionTypeVO> mappedEntriesByType = [];

  ImportModelTransactionType({required this.validation}) {
    mappedEntriesByType = _mapTypes();
  }

  ImportModelTransactionTypeVO get largest {
    ({int index, int length}) length = (index: 0, length: 0);
    for (final (index, element) in mappedEntriesByType.indexed) {
      if (element.entries.length > length.length) {
        length = (index: index, length: element.entries.length);
      }
    }
    return mappedEntriesByType.elementAt(length.index);
  }

  void remap(String typeValue, ETransactionType type) {
    final List<ImportModelTransactionTypeVO> list = [];
    for (final element in mappedEntriesByType) {
      if (element.typeValue == typeValue) {
        list.add(element.copyWith(type: type));
      } else {
        list.add(element.copyWith(type: type.toggle));
      }
    }
    mappedEntriesByType = list;
  }

  List<ImportModelTransactionTypeVO> _mapTypes() {
    final typeColumn = validation.mappedColumns
        .where((e) => e.column == EImportColumn.transactionType)
        .firstOrNull;
    // infer type from the amount sign
    if (typeColumn == null) {
      return ETransactionType.values.map(
        (e) {
          return ImportModelTransactionTypeVO(
            typeValue: e.name,
            transactionType: e,
            entries: validation.mappedEntries.where((entry) {
              return (e == ETransactionType.expense &&
                      entry.entries.any(
                        (m) =>
                            m.key.column == EImportColumn.amount &&
                            double.parse(m.value) < .0,
                      )) ||
                  (e == ETransactionType.income &&
                      entry.entries.any(
                        (m) =>
                            m.key.column == EImportColumn.amount &&
                            double.parse(m.value) >= .0,
                      ));
            }).toList(growable: false),
          );
        },
      ).toList(growable: false);
    } else {
      // we know there is only two or less types
      final Set<String> types = {};
      for (final element in validation.mappedEntries) {
        if (!element.containsKey(typeColumn)) continue;
        types.add(element[typeColumn]!);
        if (types.length == 2) break;
      }
      if (types.isEmpty) throw ArgumentError.value(types);
      final one = validation.mappedEntries
          .where((e) => e[typeColumn]! == types.elementAt(0));
      final two = types.length == 2
          ? validation.mappedEntries
              .where((e) => e[typeColumn]! == types.elementAt(1))
          : const <Map<ImportModelColumn, String>>[];
      const otherType = "__other_transaction_type__";
      return ETransactionType.values.indexed.map(
        (e) {
          return ImportModelTransactionTypeVO(
            entries: (e.$1 == 0 ? one : two).toList(growable: false),
            typeValue: types.elementAtOrNull(e.$1) ?? otherType,
            transactionType: e.$2,
          );
        },
      ).toList(growable: false);
    }
  }

  @override
  bool isReady() => true;

  @override
  void dispose() {}
}

final class ImportModelTransactionTypeVO {
  final String typeValue;
  final List<Map<ImportModelColumn, String>> entries;
  final ETransactionType transactionType;

  ImportModelTransactionTypeVO({
    required this.typeValue,
    required this.entries,
    required this.transactionType,
  });

  ImportModelTransactionTypeVO copyWith({required ETransactionType type}) {
    return ImportModelTransactionTypeVO(
      typeValue: typeValue,
      entries: entries,
      transactionType: type,
    );
  }
}
