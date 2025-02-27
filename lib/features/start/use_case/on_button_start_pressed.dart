import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/features.dart";

final class OnButtonStartPressed extends UseCase<void, dynamic> {
  @override
  Future<void> call(BuildContext context, [_]) async {
    context.go<void>(const StartAccountPage(), noTransition: true);
  }
}
