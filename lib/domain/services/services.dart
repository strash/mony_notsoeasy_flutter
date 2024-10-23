import "package:mony_app/common/extensions/extensions.dart";

export "./account.dart";
export "./category.dart";
export "./csv_import_export.dart";
export "./vo/vo.dart";

typedef TNewDefaultColumns = ({String id, DateTime now});

abstract base class BaseDomainService {
  int get perPage;

  int offset(int page) => perPage * page;

  TNewDefaultColumns get newDefaultColumns {
    final now = DateTime.now();
    return (id: StringEx.random(20), now: now);
  }
}
