import "package:mony_app/common/extensions/string.dart";

typedef TNewDefaultColumns = ({String id, DateTime now});

abstract base class BaseDatabaseService {
  int get perPage;

  int offset(int page) => perPage * page;

  TNewDefaultColumns get newDefaultColumns {
    final now = DateTime.now();
    return (id: StringEx.random(20), now: now);
  }
}
