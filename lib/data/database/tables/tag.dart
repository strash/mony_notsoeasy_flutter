import "package:drift/drift.dart";
import "package:mony_app/common/extensions/string.dart";

final class Tags extends Table {
  @override
  Set<TextColumn> get primaryKey => {id};

  TextColumn get id => text().clientDefault(() => ExString.random(20))();

  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updated => dateTime().withDefault(currentDateAndTime)();

  TextColumn get title => text().unique()();
}
