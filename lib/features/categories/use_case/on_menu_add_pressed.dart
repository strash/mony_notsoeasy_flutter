import "package:flutter/widgets.dart";
import "package:mony_app/app/event_service/event_service.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/bottom_sheet/sheet.dart";
import "package:mony_app/domain/models/transaction_type_enum.dart";
import "package:mony_app/domain/services/database/category.dart";
import "package:mony_app/domain/services/database/vo/category.dart";
import "package:mony_app/features/category_form/page/view_model.dart";
import "package:provider/provider.dart";

final class OnMenuAddPressed extends UseCase<Future<void>, ETransactionType> {
  @override
  Future<void> call(BuildContext context, [ETransactionType? value]) async {
    if (value == null) throw ArgumentError.notNull();

    final categoryService = context.read<DomainCategoryService>();
    final appService = context.viewModel<AppEventService>();

    final result = await BottomSheetComponent.show<CategoryVO?>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return CategoryFormPage(
          keyboardHeight: bottom,
          category: null,
          transactionType: value,
          additionalUsedTitles: const [],
        );
      },
    );

    if (result == null) return;

    final category = await categoryService.create(vo: result);

    appService.notify(EventCategoryCreated(category));
  }
}
