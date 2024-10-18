import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/features/features.dart";

final class OnImportDataPressedUseCase extends BaseUseCase<void> {
  @override
  void action(BuildContext context) {
    context.go(const StartAccountImportPage());
  }
}
