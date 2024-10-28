import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/page/page.dart";
import "package:provider/provider.dart";

final class OnDoneMapping extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    final viewModel = context.viewModel<ImportViewModel>();
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    final transactionService = context.read<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();

    // -> accounts
    const String singleAccountId = "__single_account__";
    final Map<String, AccountModel> accounts = {};
    if (viewModel.singleAccount != null) {
      accounts[singleAccountId] =
          await accountService.create(vo: viewModel.singleAccount!);
    } else if (viewModel.accounts.isNotEmpty) {
      for (final MapEntry(:key, :value) in viewModel.accounts.entries) {
        if (value == null) throw Exception("Account can't be null");
        accounts[key] = await accountService.create(vo: value);
      }
    }

    // -> categories
    final Map<ETransactionType, Map<String, CategoryModel>> categories = {
      for (final type in ETransactionType.values) type: {},
    };
    for (final MapEntry(key: type, value: list)
        in viewModel.mappedCategories.entries) {
      for (final (:title, :linkedModel, :vo) in list) {
        if (linkedModel != null) {
          categories[type]![title] = linkedModel;
          continue;
        }
        if (vo == null) throw Exception("Category can't be null");
        categories[type]![title] = await categoryService.create(vo: vo);
      }
    }

    // -> tags
    final Map<String, TagModel> tags = {};
    if (viewModel.mappedColumns.any((e) => e.column == EImportColumn.tag)) {
      final Set<String> tagTitles = {};
      final tagColumn = viewModel.mappedColumns
          .singleWhere((e) => e.column == EImportColumn.tag);
      for (final element in viewModel.csv!.entries) {
        if (element[tagColumn.entryKey] == null) continue;
        tagTitles.add(element[tagColumn.entryKey]!);
      }
      for (final title in tagTitles) {
        final vo = TagVO(title: title);
        tags[title] = await tagService.create(vo: vo);
      }
    }

    // -> transactions
    final List<TransactionModel> transactions = [];
    final typeColumn = viewModel.mappedColumns
        .where((e) => e.column == EImportColumn.transactionType)
        .firstOrNull;
    for (final element in viewModel.csv!.entries) {
      ETransactionType transactionType = ETransactionType.defaultValue;
      for (final MapEntry(:key, :value) in element.entries) {
        if (typeColumn != null && key == typeColumn.entryKey) {
          if (value == viewModel.mappedTransactionTypeExpense) {
            transactionType = ETransactionType.expense;
          } else if (value == viewModel.mappedTransactionTypeIncome) {
            transactionType = ETransactionType.income;
          }
          break;
        } else if (typeColumn == null &&
            viewModel.getColumn(key) == EImportColumn.amount) {
          final amount = double.parse(value);
          transactionType =
              amount < .0 ? ETransactionType.expense : ETransactionType.income;
          break;
        }
      }
      final vo = _TransactionBuilder()..addType(transactionType);
      if (viewModel.singleAccount != null) {
        vo.addAccountId(accounts[singleAccountId]!.id);
      }
      for (final MapEntry(:key, :value) in element.entries) {
        final column = viewModel.getColumn(key);
        switch (column) {
          case EImportColumn.amount:
            final amount = double.parse(value).abs();
            vo.addAmount(
              transactionType == ETransactionType.expense
                  ? .0 - amount
                  : amount,
            );
          case EImportColumn.date:
            vo.addDate(DateTime.parse(value).toLocal());
          case EImportColumn.category:
            vo.addCategoryId(categories[transactionType]![value]!.id);
          case EImportColumn.transactionType || null:
            continue;
          case EImportColumn.account:
            vo.addAccountId(accounts[value]!.id);
          case EImportColumn.tag:
            final tagModel = tags[value]!;
            vo.addTags(
              [TransactionTagVO(tagId: tagModel.id, title: tagModel.title)],
            );
          case EImportColumn.note:
            vo.addNote(value);
        }
      }
      final transaction = await transactionService.create(vo: vo.build());
      if (transaction != null) transactions.add(transaction);
    }

    // TODO: высчитывать какая получается сумма после всех
    // транзакций и ее устанавливать как изначальную

    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      appService.notify(
        Event.accountCreated(
          sender: ImportViewModel,
          account: accounts.entries.map((e) => e.value).first,
        ),
      );
    }
  }
}

final class _TransactionBuilder {
  double? amount;
  ETransactionType? type;
  DateTime? date;
  String? note;
  String? accountId;
  String? categoryId;
  List<TransactionTagVO> tags = const [];

  _TransactionBuilder addAmount(double value) {
    amount = value;
    return this;
  }

  _TransactionBuilder addType(ETransactionType value) {
    type = value;
    return this;
  }

  _TransactionBuilder addDate(DateTime value) {
    date = value;
    return this;
  }

  _TransactionBuilder addNote(String value) {
    note = value;
    return this;
  }

  _TransactionBuilder addAccountId(String value) {
    accountId = value;
    return this;
  }

  _TransactionBuilder addCategoryId(String value) {
    categoryId = value;
    return this;
  }

  _TransactionBuilder addTags(List<TransactionTagVO> value) {
    tags = value;
    return this;
  }

  TransactionVO build() {
    final amount = this.amount;
    final type = this.type;
    final date = this.date;
    final accountId = this.accountId;
    final categoryId = this.categoryId;
    if (amount == null ||
        type == null ||
        date == null ||
        accountId == null ||
        categoryId == null) {
      throw ArgumentError.notNull();
    }
    return TransactionVO(
      amout: amount,
      type: type,
      date: date,
      note: note ?? "",
      accountId: accountId,
      categoryId: categoryId,
      tags: tags,
    );
  }
}
