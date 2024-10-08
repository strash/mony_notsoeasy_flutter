#!/bin/sh

name="$1"
filename="$2"
class_name="$3"
path="data/database/migrations"

cat << EOF > $(pwd)/lib/$path/$filename
import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class $class_name extends BaseMigration {
  @override
  Future<void> up(Database db) async {
    // TODO: implement up
    throw UnimplementedError();
  }

  @override
  Future<void> down(Database db) async {
    // TODO: implement down
    throw UnimplementedError();
  }
}
EOF

echo "export \"package:mony_app/$path/$filename\";" >> "$(pwd)/lib/$path/migrations.dart"

printf "👍 Migration \"%b%s%b\" created at \"%s\"\n" "\e[1m" "$name" "\e[0m" "lib/$path/$filename"
