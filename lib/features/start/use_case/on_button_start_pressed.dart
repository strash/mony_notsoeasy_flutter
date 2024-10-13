import "package:flutter/widgets.dart";
import "package:mony_app/app/app.dart";
import "package:mony_app/common/extensions/build_context.dart";
import "package:mony_app/features/features.dart";

final class OnButtonStartPressedUseCase extends BaseUseCase<void> {
  @override
  Future<void> action(BuildContext context) async {
    context.go<void>(const StartScreenNewAccountPage(), noTransition: true);
  }
}
