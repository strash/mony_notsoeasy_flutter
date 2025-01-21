import "package:mony_app/common/extensions/string.dart";

export "./account.dart";
export "./account_balance.dart";
export "./category.dart";
export "./category_balance.dart";
export "./tag.dart";
export "./tag_balance.dart";
export "./transaction.dart";

abstract base class BaseDatabaseFactory {
  ({String id, DateTime now}) get newDefaultColumns {
    final now = DateTime.now();
    return (id: StringEx.random(20), now: now);
  }
}
