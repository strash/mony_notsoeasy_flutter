import "package:flutter/widgets.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/domain/models/transaction.dart";
import "package:mony_app/features/import/components/components.dart";
import "package:mony_app/features/import/page/view_model.dart";

typedef TPressedCategoryValue = ({
  ETransactionType transactionType,
  TMappedCategory category,
});

final class OnCategoryButtonPressed
    extends UseCase<Future<void>, TPressedCategoryValue> {
  @override
  Future<void> call(
    BuildContext context, [
    TPressedCategoryValue? value,
  ]) async {
    if (value == null) throw ArgumentError.notNull();
    // show action menu
    final sheetResult =
        await BottomSheetComponent.show<EImportCategoryMenuAction?>(
      context,
      builder: (context) => const ImportCategoryActionBottomSheetComponent(),
    );
    if (sheetResult == null) return;

    print(sheetResult);
  }
}
