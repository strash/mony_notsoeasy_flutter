# Mony App

Для работы потребуется [Just](https://github.com/casey/just).
`just` - покажет список доступных команд. Все команды можно найти в **justfile**
в корне проекта. Запускать команды можно из любого места в проекте.

## Запуск проекта

`just run` - запустит проект со всеми необходимыми настройками.

## Обновление зависимостей

`just update` - обновит зависимости до последней мажорной версии.

## Build Runner

`just build` - сгенерирует необходимые файлы.

## Миграции

### Создание миграции

`just migrate "my new cool migration"` - создаст новый файл миграции по адресу
**lib/data/database/migrations/m_1729646059_my_new_cool_migration.dart**. При
удачном создании файла миграции отобразиться сообщение.

Внутри файла создасться класс миграции, с двумя методами, которые нужно
заимплементить.
```dart
import "package:mony_app/data/database/migration_service.dart";
import "package:sqflite/sqflite.dart";

final class M1729646059MyNewCoolMigration extends BaseMigration {
  @override
  Future<void> up(Database db) async {
    // действия при накатывании этой миграции
  }

  @override
  Future<void> down(Database db) async {
    // действия при откатывании этой миграции
  }
}
```

После этого в **lib/data/database/migration_service.dart** нужно добавить этот
класс в конец списка миграций.
```dart
final class MigrationService {
  final List<BaseMigration> _migrations = [
    M1728167641Init(),
    M1728413017SecondMigration(),
    // сюда
    M1729646059MyNewCoolMigration(),
  ];
  // ...
}
```

И наконец, чтобы при следующем запуске накатилась новая миграция, нужно поднять
версию миграции в **.version** в корне проекта.
`MIGRATE_VERSION=2` -> `MIGRATE_VERSION=3`

После этого запустить/перезапустить проект.

### Удаление миграции

Чтобы удалить миграцию, нужно:
- удалить класс миграции из массива миграций в сервисе **lib/data/database/migration_service.dart**
- удалить сгенерированный файл миграции
- удалить `export "package:mony_app/data/database/migrations/<название_файла>.dart"` из файла-бочки **lib/data/database/migrations/migrations.dart**
- уменьшить версию миграций в файле **.version**

