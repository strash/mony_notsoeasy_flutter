import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:mony_app/app/use_case/use_case.dart";
import "package:mony_app/common/common.dart";
import "package:mony_app/components/components.dart";
import "package:mony_app/features/import/import.dart";
import "package:mony_app/i18n/strings.g.dart";

final class OnColumnInfoPressed extends UseCase<void, dynamic> {
  @override
  void call(BuildContext context, [_]) {
    final viewModel = context.viewModel<ImportViewModel>();
    final currentMappedColumn = viewModel.currentStep;
    if (currentMappedColumn is! ImportModelColumn) {
      throw ArgumentError.value(currentMappedColumn);
    }

    final viewSize = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final title = context.t.models.import.column_title(
      context: currentMappedColumn.column,
    );
    final description = context.t.models.import.column_description(
      context: currentMappedColumn.column,
    );

    BottomSheetComponent.show<void>(
      context,
      showDragHandle: false,
      builder: (context, bottom) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewSize.height * 0.4),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            shrinkWrap: true,
            slivers: [
              // -> title
              AppBarComponent(title: Text(title), showDragHandle: true),

              // -> description
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 15.0,
                  ),
                  child: Text(
                    description,
                    style: GoogleFonts.golosText(
                      fontSize: 16.0,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),

              SliverPadding(padding: EdgeInsets.only(bottom: bottom + 40.0)),
            ],
          ),
        );
      },
    );
  }
}
