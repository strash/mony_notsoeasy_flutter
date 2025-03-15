import "dart:ui";

import "package:mony_app/app/theme/theme.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/data/database/migration_service.dart";
import "package:mony_app/domain/domain.dart";
import "package:sqflite/sqflite.dart";

typedef _TI18n = ({String en, String ru});
typedef _TCategoryVO = ({String icon, String color, _TI18n title});

extension on _TCategoryVO {
  String tr(Locale? locale) {
    return switch (locale?.languageCode.toLowerCase()) {
      "ru" => title.ru,
      "en" || null || _ => title.en,
    };
  }
}

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
    final locale = PlatformDispatcher.instance.locales.firstOrNull;
    final batch = db.batch();

    // expense categories
    final expenseCategories = <_TCategoryVO>[
      (
        icon: "🛒",
        color: EColorName.maximumBluePurple.name,
        title: (en: "Groceries", ru: "Продукты"),
      ),
      (
        icon: "🍔",
        color: EColorName.philippineYellow.name,
        title: (en: "Food", ru: "Еда"),
      ),
      (
        icon: "😍",
        color: EColorName.americanOrange.name,
        title: (en: "Self Care", ru: "Забота о себе"),
      ),
      (
        icon: "🐶",
        color: EColorName.cafeAuLait.name,
        title: (en: "Pets", ru: "Питомцы"),
      ),
      (
        icon: "🏠",
        color: EColorName.bananaYellow.name,
        title: (en: "Rent", ru: "Аренда"),
      ),
      (
        icon: "🚑",
        color: EColorName.inchworm.name,
        title: (en: "Healthcare", ru: "Здоровье"),
      ),
      (
        icon: "🚖",
        color: EColorName.corn.name,
        title: (en: "Transport", ru: "Транспорт"),
      ),
      (
        icon: "🔄",
        color: EColorName.babyBlue.name,
        title: (en: "Subscriptions", ru: "Подписки"),
      ),
      (
        icon: "🧦",
        color: EColorName.richBrilliantLavender.name,
        title: (en: "Fashion", ru: "Гардероб"),
      ),
      (
        icon: "🎁",
        color: EColorName.mauvelous.name,
        title: (en: "Gifts", ru: "Подарки"),
      ),
      (
        icon: "🪴",
        color: EColorName.vividMalachite.name,
        title: (en: "Home", ru: "Дом"),
      ),
      (
        icon: "💻",
        color: EColorName.cadet.name,
        title: (en: "Electronics", ru: "Девайсы"),
      ),
    ];
    for (final category in expenseCategories) {
      batch.execute(
        _getInsertQuery(
          icon: category.icon,
          title: category.tr(locale),
          colorName: category.color,
          transactionType: ETransactionType.expense.value,
        ),
      );
    }

    // income categories
    final incomeCategories = <_TCategoryVO>[
      (
        icon: "🤑",
        color: EColorName.vividMalachite.name,
        title: (en: "Paycheck", ru: "Зарплата"),
      ),
      (
        icon: "💼",
        color: EColorName.azure.name,
        title: (en: "Freelance", ru: "Фриланс"),
      ),
      (
        icon: "🧧",
        color: EColorName.mauvelous.name,
        title: (en: "Gifts", ru: "Подарки"),
      ),
      (
        icon: "💹",
        color: EColorName.bananaYellow.name,
        title: (en: "Investments", ru: "Инвестиции"),
      ),
      (
        icon: "🪙",
        color: EColorName.inchworm.name,
        title: (en: "Tips", ru: "Чаевые"),
      ),
      (
        icon: "💸",
        color: EColorName.cafeAuLait.name,
        title: (en: "Loan", ru: "Займ"),
      ),
      (
        icon: "🧾",
        color: EColorName.majorelleBlue.name,
        title: (en: "Sales", ru: "Продажи"),
      ),
    ];
    for (final category in incomeCategories) {
      batch.execute(
        _getInsertQuery(
          icon: category.icon,
          title: category.tr(locale),
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
