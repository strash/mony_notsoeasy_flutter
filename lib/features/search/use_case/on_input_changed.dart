import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";

final class OnInputChanged extends UseCase<Future<void>, String> {
  @override
  Future<void> call(BuildContext context, [String? value]) async {
    if (value == null) throw ArgumentError.notNull();

    print(value);
  }
}
