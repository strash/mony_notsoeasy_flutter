import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/search/page/page.dart";

final class OnSearchPressed extends UseCase<Future<void>, double> {
  bool _isSearchOpened = false;

  @override
  Future<void> call(BuildContext context, [double? distance]) async {
    if (_isSearchOpened) return;
    if (distance == null) throw ArgumentError.notNull();
    _isSearchOpened = true;

    final result = await SearchPage.show(context, distance: distance);
    _isSearchOpened = false;
  }
}
