import "package:flutter/material.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/extensions.dart";
import "package:mony_app/domain/domain.dart";
import "package:mony_app/features/import/page/page.dart";
import "package:provider/provider.dart";

final class OnDoneMapping extends UseCase<Future<void>, dynamic> {
  @override
  Future<void> call(BuildContext context, [dynamic _]) async {
    const int wait = 3;
    final start = DateTime.now();

    final navigator = Navigator.of(context);
    final viewModel = context.viewModel<ImportViewModel>();
    final accountService = context.read<DomainAccountService>();
    final categoryService = context.read<DomainCategoryService>();
    final tagService = context.read<DomainTagService>();
    final transactionService = context.read<DomainTransactionService>();
    final appService = context.viewModel<AppEventService>();

    final csvModel = ArgumentError.checkNotNull(viewModel.csv);

    // -> accounts

    const singlAccountKey = "__single_account__";
    final accountModel = ArgumentError.checkNotNull(
      viewModel.steps.whereType<ImportModelAccount>().firstOrNull,
    );
    final Map<String, AccountModel> accounts = Map.fromEntries(
      await Future.wait<MapEntry<String, AccountModel>>(
        accountModel.accounts.where((e) => e.account != null).map((e) async {
          final account = await accountService.create(vo: e.account!);
          return Future.value(
            MapEntry(e.originalTitle ?? singlAccountKey, account),
          );
        }),
      ),
    );

    // -> categories

    final categoryModel = ArgumentError.checkNotNull(
      viewModel.steps.whereType<ImportModelCategory>().firstOrNull,
    );
    final mappedCategories = categoryModel.mappedCategories.value;
    final Map<ETransactionType, Map<String, CategoryModel>> categories = {
      for (final MapEntry(key: type, value: list) in mappedCategories.entries)
        type.transactionType: Map.fromEntries(
          await Future.wait<MapEntry<String, CategoryModel>>(
            list.where((e) => e is! ImportModelCategoryVOEmpty).map((e) async {
              if (e case ImportModelCategoryVOModel(:final model)) {
                return Future.value(MapEntry(e.originalTitle, model));
              }
              final item = e as ImportModelCategoryVOVO;
              final category = await categoryService.create(vo: item.vo);
              return Future.value(MapEntry(e.originalTitle, category));
            }),
          ),
        ),
    };

    // -> tags

    final Map<String, TagModel> tags = {};
    if (viewModel.mappedColumns.any((e) => e.column == EImportColumn.tag)) {
      final tagColumn = viewModel.mappedColumns.singleWhere((e) {
        return e.column == EImportColumn.tag;
      });
      final tagTitles = Set<String>.from(
        csvModel.entries.map((e) => e[tagColumn.columnKey]).nonNulls,
      );
      tags.addEntries(
        await Future.wait(
          tagTitles.map((title) async {
            TagModel? model = await tagService.getOne(title: title);
            model ??= await tagService.create(vo: TagVO(title: title));
            return MapEntry(title, model);
          }),
        ),
      );
    }

    // -> transactions

    final typeModel = ArgumentError.checkNotNull(
      viewModel.steps.whereType<ImportModelTransactionType>().firstOrNull,
    );
    final List<TransactionModel> transactions = [];
    for (final element in typeModel.mappedEntriesByType) {
      final ImportModelTransactionTypeVO(:entries, :transactionType) = element;
      final models = await Future.wait(
        entries.map((e) {
          final builder = _TransactionBuilder();
          for (final MapEntry(:key, :value) in e.entries) {
            switch (key.column) {
              case EImportColumn.amount:
                final amount = double.parse(value).abs();
                final isExpense = transactionType == ETransactionType.expense;
                builder.addAmount(isExpense ? .0 - amount : amount);
              case EImportColumn.date:
                builder.addDate(DateTime.parse(value).toLocal());
              case EImportColumn.category:
                if (categories.containsKey(transactionType) &&
                    categories[transactionType]!.containsKey(value)) {
                  builder
                      .addCategoryId(categories[transactionType]![value]!.id);
                }
              case EImportColumn.transactionType:
                continue;
              case EImportColumn.account:
                if (accounts.containsKey(value)) {
                  builder.addAccountId(accounts[value]!.id);
                }
              case EImportColumn.tag:
                if (tags.containsKey(value)) {
                  // FIXME: предполагается, что из CSV будет только один таг. но
                  // если будут другие способы импорта, то нужно поправить
                  builder.addTags([tags[value]!]);
                }
              case EImportColumn.note:
                builder.addNote(value);
            }
          }
          // NOTE: in case theres only one required account
          if (builder._accountId == null) {
            if (accounts.containsKey(singlAccountKey)) {
              builder.addAccountId(accounts[singlAccountKey]!.id);
            }
          }
          final (:vo, tags: list) = builder.build();
          return transactionService.create(
            vo: vo,
            tags: list
                .map((e) => TransactionTagVariantModel(e))
                .toList(growable: false),
          );
        }),
      );
      transactions.addAll(models.nonNulls);
    }

    // -> update account balance

    for (final MapEntry(value: account) in accounts.entries) {
      final sum = transactions
          .where((e) => e.account.id == account.id)
          .fold(.0, (prev, next) => prev + next.amount);
      await accountService.update(
        model: account.copyWith(balance: account.balance - sum),
      );
    }

    // -> wait a bit

    final diff = DateTime.now().difference(start);
    if (diff.inSeconds < wait) {
      await Future.delayed(const Duration(seconds: wait) - diff);
    }

    // -> go to the main screen

    final account = accounts.entries.map((e) => e.value).first;
    navigator.popUntil((route) => route.isFirst);

    appService.notify(EventAccountCreated(account));
  }
}

final class _TransactionBuilder {
  double? _amount;
  DateTime? _date;
  String? _note;
  String? _accountId;
  String? _categoryId;
  List<TagModel> _tags = const [];

  _TransactionBuilder addAmount(double value) {
    _amount = value;
    return this;
  }

  _TransactionBuilder addDate(DateTime value) {
    _date = value;
    return this;
  }

  _TransactionBuilder addNote(String value) {
    _note = value;
    return this;
  }

  _TransactionBuilder addAccountId(String value) {
    _accountId = value;
    return this;
  }

  _TransactionBuilder addCategoryId(String value) {
    _categoryId = value;
    return this;
  }

  _TransactionBuilder addTags(List<TagModel> value) {
    _tags = value;
    return this;
  }

  ({TransactionVO vo, List<TagModel> tags}) build() {
    final amount = _amount;
    final date = _date;
    final accountId = _accountId;
    final categoryId = _categoryId;
    if (amount == null ||
        date == null ||
        accountId == null ||
        categoryId == null) {
      throw ArgumentError.notNull();
    }
    return (
      vo: TransactionVO(
        amout: amount,
        date: date,
        note: _note ?? "",
        accountId: accountId,
        categoryId: categoryId,
      ),
      tags: _tags,
    );
  }
}
