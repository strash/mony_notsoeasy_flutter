import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/features/search/page/view_model.dart";

typedef _Type = ({
  double distance,
  AnimationStatusListener statusListener,
});

final class OnSearchPressed extends UseCase<Future<void>, _Type> {
  bool _isSearchOpened = false;

  @override
  Future<void> call(BuildContext context, [_Type? value]) async {
    if (_isSearchOpened) return;
    if (value == null) throw ArgumentError.notNull();
    _isSearchOpened = true;

    final result = await SearchPage.show(
      context,
      distance: value.distance,
      statusListener: value.statusListener,
    );
    _isSearchOpened = false;
  }
}
