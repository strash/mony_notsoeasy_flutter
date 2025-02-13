import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/data/database/migration_service.dart";
import "package:mony_app/domain/domain.dart";
import "package:sqflite/sqflite.dart";

typedef _CategoryValueObject = ({String icon, String color, String title});

final class M1728413017SeedDefaultCategories extends BaseMigration {
  final _categories = "categories";
  final _categoriesId = "id";
  final _categoriesCreated = "created";
  final _categoriesUpdated = "updated";
  final _categoriesTitle = "title";
  final _categoriesIcon = "icon";
  final _categoriesColorName = "color_name";
  final _categoriesTransactionType = "transaction_type";

  String _getInsertQuery({
    required String title,
    required String icon,
    required String colorName,
    required String transactionType,
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
	$_categoriesColorName,
	$_categoriesTransactionType
) VALUES(
	'$id',
	'$date',
	'$date',
	'$title',
	'$icon',
	'$colorName',
	'$transactionType'
	);
""";
  }

  @override
  Future<void> up(Database db) async {
    final batch = db.batch();
    // expense categories
    final expenseCategories = <_CategoryValueObject>[
      (icon: "🛒", color: EColorName.maximumBluePurple.name, title: "Продукты"),
      (icon: "🍔", color: EColorName.philippineYellow.name, title: "Еда"),
      (
        icon: "😍",
        color: EColorName.americanOrange.name,
        title: "Забота о себе",
      ),
      (icon: "🐶", color: EColorName.cafeAuLait.name, title: "Питомцы"),
      (icon: "🏠", color: EColorName.bananaYellow.name, title: "Аренда"),
      (icon: "🚑", color: EColorName.inchworm.name, title: "Здоровье"),
      (icon: "🚖", color: EColorName.corn.name, title: "Транспорт"),
      (icon: "🔄", color: EColorName.babyBlue.name, title: "Подписки"),
      (
        icon: "🧦",
        color: EColorName.richBrilliantLavender.name,
        title: "Гардероб",
      ),
      (icon: "🎁", color: EColorName.mauvelous.name, title: "Подарки"),
      (icon: "🪴", color: EColorName.vividMalachite.name, title: "Дом"),
      (icon: "💻", color: EColorName.cadet.name, title: "Девайсы"),
    ];
    for (final category in expenseCategories) {
      batch.execute(
        _getInsertQuery(
          icon: category.icon,
          title: category.title,
          colorName: category.color,
          transactionType: ETransactionType.expense.value,
        ),
      );
    }

    // income categories
    final incomeCategories = <_CategoryValueObject>[
      (icon: "🤑", color: EColorName.vividMalachite.name, title: "Зарплата"),
      (icon: "💼", color: EColorName.azure.name, title: "Фриланс"),
      (icon: "🧧", color: EColorName.mauvelous.name, title: "Подарки"),
      (icon: "💹", color: EColorName.bananaYellow.name, title: "Инверстиции"),
      (icon: "🪙", color: EColorName.inchworm.name, title: "Чаевые"),
      (icon: "💸", color: EColorName.cafeAuLait.name, title: "Займ"),
      (icon: "🧾", color: EColorName.majorelleBlue.name, title: "Продажи"),
    ];
    for (final category in incomeCategories) {
      batch.execute(
        _getInsertQuery(
          icon: category.icon,
          title: category.title,
          colorName: category.color,
          transactionType: ETransactionType.income.value,
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
