import "package:mony_app/common/extensions/string.dart";
import "package:mony_app/data/database/migration_service.dart";
import "package:mony_app/domain/domain.dart";
import "package:sqflite/sqflite.dart";

typedef _CategoryValueObject = ({String icon, String title});

final class M1728413017SeedDefaultCategories extends BaseMigration {
  final _categories = "categories";
  final _categoriesId = "id";
  final _categoriesCreated = "created";
  final _categoriesUpdated = "updated";
  final _categoriesTitle = "title";
  final _categoriesIcon = "icon";
  final _categoriesSort = "sort";
  final _categoriesExpenseType = "expense_type";

  String _getInsertQuery({
    required String title,
    required String icon,
    required int sort,
    required String expenseType,
  }) {
    final id = StringEx.random(20);
    final date = DateTime.now().toUtc().toIso8601String();
    return """
INSERT INTO $_categories (
	$_categoriesId,
	$_categoriesCreated,
	$_categoriesUpdated,
	$_categoriesTitle,
	$_categoriesIcon,
	$_categoriesSort,
	$_categoriesExpenseType
) VALUES('$id', '$date', '$title', '$icon', $sort, '$expenseType');
""";
  }

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();
    // expense categories
    final expenseCategories = <_CategoryValueObject>[
      (icon: "🛒", title: "Продукты"),
      (icon: "🍔", title: "Еда"),
      (icon: "😍", title: "Забота о себе"),
      (icon: "🐶", title: "Питомцы"),
      (icon: "🏠", title: "Аренда"),
      (icon: "🚑", title: "Здоровье"),
      (icon: "🚖", title: "Транспорт"),
      (icon: "🔄", title: "Подписки"),
      (icon: "🧦", title: "Гардероб"),
      (icon: "🎁", title: "Подарки"),
      (icon: "🪴", title: "Дом"),
    ];
    for (final category in expenseCategories.indexed) {
      batch.execute(
        _getInsertQuery(
          icon: category.$2.icon,
          title: category.$2.title,
          sort: category.$1,
          expenseType: EExpenseType.expense.value,
        ),
      );
    }

    // income categories
    final incomeCategories = <_CategoryValueObject>[
      (icon: "🤑", title: "Зарплата"),
      (icon: "💼", title: "Фриланс"),
      (icon: "🧧", title: "Подарки"),
      (icon: "💹", title: "Инверстиции"),
      (icon: "🪙", title: "Чаевые"),
      (icon: "💸", title: "Займ"),
      (icon: "🧾", title: "Продажи"),
    ];
    for (final category in incomeCategories.indexed) {
      batch.execute(
        _getInsertQuery(
          icon: category.$2.icon,
          title: category.$2.title,
          sort: category.$1,
          expenseType: EExpenseType.income.value,
        ),
      );
    }
    await batch.commit();
  }

  @override
  Future<void> down(Database db) async {
    await db.delete(_categories);
  }
}